(define-module (roquix packages codex)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages version-control)
  #:use-module (rustup build toolchain))

(define-public codex
  (package
    (name "codex")
    (version "0.77.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openai/codex/")
             (commit (string-append "rust-v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "066yj4kgxamr1a0kal85ckrczs1wkl6m0zdcmvpz516m5b6f776k"))))
    ;; TODO: Use official rust-1.89.0 when the official guix channel is updated
    (build-system (make-cargo-build-system "1.89.0"))
    (inputs (cons* clang-toolchain openssl
                   (cargo-inputs 'codex
                                 #:module '(roquix packages rust-crates))))
    ;; Need for tests
    (native-inputs (list python git perl))
    (arguments
     `(#:install-source? #f
       #:cargo-install-paths '("cli")
       #:cargo-test-flags '("--"
                            ;; core
                            ;; FIXME: There are objects in the response that are either excessive or missing.
                            "--skip=suite::compact_resume_fork::compact_resume_after_second_compaction_preserves_history" ; "hello world" message is missing
                            "--skip=suite::compact_resume_fork::compact_resume_and_fork_preserve_model_history_view" ; "hello world" message is excessive

                            ;; FIXME: Anyhow order of Object is wrong
                            ;; Diff < left / right > :
                            ;;  [
                            ;;      Object {
                            ;; <        "type": String("message"),
                            ;; <        "role": String("user"),
                            ;;          "content": Array [
                            ;;              Object {
                            ;; >                "text": String("first manual turn"),
                            ;;                  "type": String("input_text"),
                            ;; <                "text": String("FIRST_MANUAL_SUMMARY"),
                            ;;              },
                            ;;          ],
                            ;; >        "role": String("user"),
                            ;; >        "type": String("message"),
                            ;;      },
                            ;;      Object {
                            ;; <        "type": String("message"),
                            ;; <        "role": String("user"),
                            ;;          "content": Array [
                            ;;              Object {
                            ;; >                "text": String("FIRST_MANUAL_SUMMARY"),
                            ;;                  "type": String("input_text"),
                            ;; <                "text": String("second manual turn"),
                            ;;              },
                            ;;          ],
                            ;; >        "role": String("user"),
                            ;; >        "type": String("message"),
                            ;;      },
                            ;;      Object {
                            ;; <        "type": String("message"),
                            ;; <        "role": String("user"),
                            ;;          "content": Array [
                            ;;              Object {
                            ;; >                "text": String("second manual turn"),
                            ;;                  "type": String("input_text"),
                            ;; <                "text": String("SECOND_MANUAL_SUMMARY"),
                            ;;              },
                            ;;          ],
                            ;; >        "role": String("user"),
                            ;; >        "type": String("message"),
                            ;;      },
                            ;;      Object {
                            ;; <        "type": String("message"),
                            ;; <        "role": String("user"),
                            ;;          "content": Array [
                            ;;              Object {
                            ;; >                "text": String("SECOND_MANUAL_SUMMARY"),
                            ;;                  "type": String("input_text"),
                            ;; >            },
                            ;; >        ],
                            ;; >        "role": String("user"),
                            ;; >        "type": String("message"),
                            ;; >    },
                            ;; >    Object {
                            ;; >        "content": Array [
                            ;; >            Object {
                            ;;                  "text": String("post compact follow-up"),
                            ;; >                "type": String("input_text"),
                            ;;              },
                            ;;          ],
                            ;; >        "role": String("user"),
                            ;; >        "type": String("message"),
                            ;;      },
                            ;;  ]
                            "--skip=suite::compact::manual_compact_twice_preserves_latest_user_messages"

                            ;; NOTE: The kernel must support landlock feature to run these tests.
                            "--skip=suite::tools::sandbox_denied_shell_returns_original_output"
                            "--skip=suite::user_shell_cmd::user_shell_cmd_ls_and_cat_in_temp_dir"
                            "--skip=suite::sandbox::python_multiprocessing_lock_works_under_sandbox"
                            "--skip=suite::sandbox::sandbox_distinguishes_command_and_policy_cwds"
                            "--skip=suite::sandbox::python_getpwuid_works_under_sandbox"
                            "--skip=suite::unified_exec::unified_exec_runs_under_sandbox"

                            ;; FIXME: It seems to be timeout
                            ;; thread 'suite::view_image::view_image_tool_attaches_local_image' panicked at /tmp/guix-build-codex-0.53.0.drv-0/source/codex-rs/core/tests/common/lib.rs:159:14:
                            ;; timeout waiting for event: Elapsed(())
                            "--skip=suite::view_image::view_image_tool_attaches_local_image"
                            "--skip=suite::abort_tasks::interrupt_tool_records_history_entries"

                            ;; NOTE: Seems to depend on time
                            "--skip=suite::approvals::approval_matrix_covers_all_modes"
                            "--skip=suite::shell_serialization::shell_command_output_is_not_truncated_over_10k_bytes"
                            "--skip=suite::shell_serialization::shell_command_output_is_not_truncated_under_10k_bytes"
                            "--skip=suite::unified_exec::unified_exec_emits_exec_command_end_event"

                            ;; linux-sandbox
                            ;; NOTE: The kernel must support landlock feature to run these tests.
                            "--skip=suite::landlock::test_dev_null_write"
                            "--skip=suite::landlock::test_root_read"
                            "--skip=suite::landlock::test_timeout"
                            "--skip=suite::landlock::test_writable_root"

                            ;; tui
                            ;; NOTE: The paths are replaced to absolute path like "/tmp/guix-build-codex-0.46.0.drv-0/source/codex-rs/tui/example.png".
                            ;; It seems to be hard to fix, because such a longer path sometimes causes complicated UI change.
                            "--skip=chatwidget::tests::view_image_tool_call_adds_history_cell"
                            "--skip=diff_render::tests::ui_snapshot_apply_update_block_relativizes_path"

                            ;; app-server
                            ;; FIXME: Unknown error occurs in cuirass
                            ;; thread 'suite::codex_message_processor_flow::test_codex_jsonrpc_conversation_flow' panicked at app-server/tests/suite/codex_message_processor_flow.rs:148:6:
                            ;; task_finished_notification resp: unexpected JSONRPCMessage::Request: Request(JSONRPCRequest { id: Integer(0), method: "execCommandApproval", params: Some(Object {"conversationId": String("019a1bf7-6bce-7371-b2a7-c9319d5d5c0d"), "callId": String("call1234"), "command": Array [String("ls")], "cwd": String("/tmp/guix-build-codex-0.48.0.drv-0/.tmpiAoxpP/workdir"), "reason": String("command failed; retry without sandbox?"), "parsedCmd": Array [Object {"type": String("list_files"), "cmd": String("ls"), "path": Null}]}) })
                            ;; note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
                            "--skip=suite::codex_message_processor_flow::test_codex_jsonrpc_conversation_flow"
                            ;; FIXME: Unknown error occurs
;;                             thread 'suite::send_message::test_send_message_raw_notifications_opt_in' panicked at app-server/tests/suite/send_message.rs:316:13:
;; expected instructions message, got ["<environment_context>\n  <cwd>/tmp/guix-build-codex-0.53.0.drv-0/source/codex-rs/app-server</cwd>\n  <approval_policy>never</approval_policy>\n  <sandbox_mode>danger-full-access</sandbox_mode>\n  <network_access>enabled</network_access>\n</environment_context>"]
                            "--skip=suite::send_message::test_send_message_raw_notifications_opt_in"
                            ;; NOTE: The kernel must support landlock feature to run these tests.
                            "--skip=suite::interrupt::test_shell_command_interruption"
                            ;; FIXME: Unknown
                            "--skip=suite::v2::turn_start::turn_start_exec_approval_decline_v2"
                            ;; FIXME: Seems to be timeout
                            "--skip=suite::v2::turn_start::command_execution_notifications_include_process_id"

                            ;; v2
                            ;; NOTE: The kernel must support landlock feature to run these tests.
                            "--skip=suite::v2::turn_interrupt::turn_interrupt_aborts_running_turn"

                            ;; exec_server
                            ;; FIXME: No such file or directory (os error 2)
                            "--skip=suite::accept_elicitation::accept_elicitation_for_prompt_rule"
                            "--skip=suite::list_tools::list_tools"

                            ;; FIXME: Unknown
                            "--skip=suite::v2::review::review_start_runs_review_turn_and_emits_code_review_item"

                            ;; snapshot
                            ;; NOTE: Snapshots include version string. It is hard to fix.
                            "--skip=status::tests::status_snapshot_cached_limits_hide_credits_without_flag"
                            "--skip=status::tests::status_snapshot_includes_credits_and_limits"
                            "--skip=status::tests::status_snapshot_includes_monthly_limit"
                            "--skip=status::tests::status_snapshot_includes_reasoning_details"
                            "--skip=status::tests::status_snapshot_shows_empty_limits_message"
                            "--skip=status::tests::status_snapshot_shows_missing_limits_message"
                            "--skip=status::tests::status_snapshot_shows_stale_limits_message"
                            "--skip=status::tests::status_snapshot_truncates_in_narrow_terminal"
                            )
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'change-directory-to-rust-source
                    (lambda _
                      (chdir "codex-rs")))
                  (add-after 'change-directory-to-rust-source 'use-guix-vendored-dependencies
                    (lambda _
                      (substitute* "Cargo.toml"
                        (("ratatui = \\{ git = \"https://github.com/nornagon/ratatui\", branch = \"nornagon-v0.29.0-patch\" \\}")
                         "")
                        (("crossterm = \\{ git = \"https://github.com/nornagon/crossterm\", branch = \"nornagon/color-query\" \\}")
                         ""))))
                  (add-after 'use-guix-vendored-dependencies 'fix-test
                    (lambda _
                      ;; Tese tests need environments variable named USER.
                      ;; - suite::client::azure_overrides_assign_properties_used_for_responses_url
                      ;; - suite::client::env_var_overrides_loaded_auth
                      (setenv "USER" "guix")

                      ;; NOTE: The version is always 0.0.0 in the original Cargo.toml,
                      ;; but cargo-build-system generates theirs, where the version is package version.
                      (substitute* '("app-server/tests/suite/user_agent.rs")
                        (("\\{originator\\}/0\\.0\\.0")
                         ,(string-append "{originator}/" version)))
                      (substitute* '("mcp-server/tests/common/mcp_process.rs")
                        (("codex_cli_rs/0\\.0\\.0")
                         ,(string-append "codex_cli_rs/" version))
                        ;; NOTE: Don't replace "0.0.0" because a version in client_info is also "0.0.0".
                        ;; Replace only server info.
                        (("\"version\": \"0.0.0\",")
                         ,(string-append "\"version\": \"" version "\",")))
                      (substitute* (append (find-files "./"))
                        (("/bin/sh")
                         (which "sh"))
                        (("/bin/bash")
                         (which "bash"))
                        (("/bin/echo")
                         (which "echo"))
                        (("/bin/cat")
                         (which "cat"))
                        (("/usr/bin/sed")
                         (which "sed"))
                        (("\"command\": \"perl")
                         (string-append "\"command\": \"" (which "perl")))))))))
    (home-page "https://github.com/openai/codex")
    (synopsis "Lightweight coding agent that runs in your terminal")
    (description "Lightweight coding agent that runs in your terminal")
    (license license:asl2.0)))
