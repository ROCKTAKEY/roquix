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
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages compression)
  #:use-module (gnu packages gcc)
  #:use-module (gnu packages commencement)
  #:use-module (gnu packages cmake)
  #:use-module (gnu packages libunwind)
  #:use-module (gnu packages sqlite)
  #:use-module (gnu packages linux))

(define-public codex
  (package
    (name "codex")
    (version "0.104.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openai/codex/")
             (commit (string-append "rust-v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "10kafm9k6l524jfzq0ggas41szd0qjbr252fxjkdd5r3dgz9p5dj"))))
    (build-system cargo-build-system)
    (inputs (cons* ;; clang-toolchain
                   openssl `(,zstd "lib") gcc-toolchain libunwind sqlite
                   libcap               ; codex-linux-sandbox
                   (cargo-inputs 'codex
                                 #:module '(roquix packages rust-crates))))
    (native-inputs (list
                    pkg-config
                    cmake
                    ;; Need for tests
                    python git perl))
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
                            ;; FIXME: Unknown
                            ;; thread 'suite::approvals::approving_apply_patch_for_session_skips_future_prompts_for_same_file' panicked at core/tests/suite/approvals.rs:596:38:
                            ;; expected patch approval request before completion
                            ;; note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
                            "--skip=suite::approvals::approving_apply_patch_for_session_skips_future_prompts_for_same_file"
                            ;; FIXME: Unknown
                            ;; Diff < left / right > :
                            ;; <1
                            ;; >2
                            "--skip=suite::pending_input::injected_user_input_triggers_follow_up_request_with_deltas"

                            ;; v2
                            ;; NOTE: The kernel must support landlock feature to run these tests.
                            "--skip=suite::v2::turn_interrupt::turn_interrupt_aborts_running_turn"
                            ;; FIXME: Unknown
                            "--skip=suite::v2::review::review_start_runs_review_turn_and_emits_code_review_item"

                            ;; exec_server
                            ;; FIXME: No such file or directory (os error 2)
                            "--skip=suite::accept_elicitation::accept_elicitation_for_prompt_rule"
                            "--skip=suite::list_tools::list_tools"

                            ;; snapshot
                            ;; NOTE: Snapshots include version string. It is hard to fix.
                            "--skip=status::tests::status_snapshot_"

                            ;; FIXME: Uninvestigated
                            "--skip=codex::tests::rejects_escalated_permissions_when_policy_not_on_request"
                            "--skip=exec::tests::kill_child_process_group_kills_grandchildren_on_timeout"
                            "--skip=exec::tests::process_exec_tool_call_respects_cancellation_token"
                            "--skip=shell::tests::can_run_on_shell_test"
                            "--skip=shell::tests::detects_bash"
                            "--skip=shell::tests::detects_sh"
                            "--skip=shell_snapshot::tests::bash_snapshot_filters_invalid_exports"
                            "--skip=shell_snapshot::tests::snapshot_shell_does_not_inherit_stdin"
                            "--skip=shell_snapshot::tests::timed_out_snapshot_shell_is_terminated"
                            "--skip=shell_snapshot::tests::try_new_creates_and_deletes_snapshot_file"
                            "--skip=suite::shell_serialization::local_shell_call_output_is_structured"
                            "--skip=suite::shell_serialization::shell_output_for_freeform_tool_records_duration::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_for_freeform_tool_records_duration::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_for_freeform_tool_records_duration::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_for_freeform_tool_records_duration::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_for_freeform_tool_records_duration::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_for_freeform_tool_records_duration::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_for_nonzero_exit::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_for_nonzero_exit::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_for_nonzero_exit::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_for_nonzero_exit::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_for_nonzero_exit::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_for_nonzero_exit::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_preserves_fixture_json_without_serialization::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_preserves_fixture_json_without_serialization::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_preserves_fixture_json_without_serialization::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_preserves_fixture_json_without_serialization::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_reserializes_truncated_content::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_reserializes_truncated_content::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_reserializes_truncated_content::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_reserializes_truncated_content::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_stays_json_without_freeform_apply_patch::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_stays_json_without_freeform_apply_patch::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_stays_json_without_freeform_apply_patch::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_stays_json_without_freeform_apply_patch::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_structures_fixture_with_serialization::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_structures_fixture_with_serialization::shellmodeloutput_localshell_expects"
                            "--skip=suite::shell_serialization::shell_output_structures_fixture_with_serialization::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_structures_fixture_with_serialization::shellmodeloutput_shell_expects"
                            "--skip=suite::shell_serialization::shell_output_structures_fixture_with_serialization::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::shell_serialization::shell_output_structures_fixture_with_serialization::shellmodeloutput_shellcommand_expects"
                            "--skip=suite::tool_harness::shell_tool_executes_command_and_streams_output"
                            "--skip=suite::tools::shell_escalated_permissions_rejected_then_ok"
                            "--skip=suite::tools::shell_timeout_handles_background_grandchild_stdout"
                            "--skip=suite::tools::shell_timeout_includes_timeout_prefix_and_metadata"
                            "--skip=suite::unified_exec::unified_exec_emits_end_event_when_session_dies_via_stdin"
                            "--skip=suite::unified_exec::unified_exec_emits_terminal_interaction_for_write_stdin"
                            "--skip=suite::unified_exec::unified_exec_reuses_session_via_stdin"
                            "--skip=suite::unified_exec::write_stdin_returns_exit_metadata_and_clears_session"
                            "--skip=posix::escalate_server::tests::handle_escalate_session_executes_escalated_command"
                            "--skip=program_resolver::tests::test_resolved_program_executes_successfully"
                            "--skip=program_resolver::tests::test_unix_executes_script_without_extension"
                            "--skip=suite::remote_models::remote_models_merge_preserves_bundled_models_on_empty_response"
                            "--skip=external_editor::tests::run_editor_returns_updated_content"

                            "--skip=suite::user_shell_cmd::user_shell_cmd_can_be_interrupted"
                            "--skip=external_editor::tests::run_editor_returns_updated_content"
                            "--skip=tests::pipe_and_pty_share_interface"
                            "--skip=tests::pipe_process_detaches_from_parent_session"

                            "--skip=registry::tests::hook_executes_program_with_payload_argument_unix"
                            "--skip=drop_kills_wrapper_process_group"

                            "--skip=tools::runtimes::tests::maybe_wrap_shell_lc_with_snapshot_applies_explicit_path_override"
                            "--skip=tools::runtimes::tests::maybe_wrap_shell_lc_with_snapshot_does_not_embed_override_values_in_argv"
                            "--skip=tools::runtimes::tests::maybe_wrap_shell_lc_with_snapshot_keeps_snapshot_path_without_override"
                            "--skip=tools::runtimes::tests::maybe_wrap_shell_lc_with_snapshot_preserves_unset_override_variables"
                            "--skip=tools::runtimes::tests::maybe_wrap_shell_lc_with_snapshot_restores_explicit_override_precedence"

                            )
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'change-directory-to-rust-source
                    (lambda _
                      (chdir "codex-rs")))
                  (add-after 'change-directory-to-rust-source 'use-guix-vendored-dependencies
                    (lambda _
                      (substitute* "Cargo.toml"
                        (("runfiles = \\{ git = \"https://github.com/dzbarsky/rules_rust\", rev = \"b56cbaa8465e74127f1ea216f813cd377295ad81\" \\}")
                         "runfiles = \"0.1.0\"")
                        (("nucleo = \\{ git = \"https://github.com/helix-editor/nucleo.git\", rev = \"4253de9faabb4e5c6d81d946a5e35a90f87347ee\" \\}")
                         "nucleo = \"0.5.0\"")
                        (("ratatui = \\{ git = \"https://github.com/nornagon/ratatui\", branch = \"nornagon-v0.29.0-patch\" \\}")
                         "")
                        (("crossterm = \\{ git = \"https://github.com/nornagon/crossterm\", branch = \"nornagon/color-query\" \\}")
                         "")
                        (("tokio-tungstenite = \\{ git = \"https://github.com/openai-oss-forks/tokio-tungstenite\", rev = \"132f5b39c862e3a970f731d709608b3e6276d5f6\" \\}")
                         "")
                        (("\\[patch.\"ssh://git@github.com/JakkuSakura/tungstenite-rs.git\"\\]")
                         "")
                        (("tungstenite = \\{ git = \"https://github.com/openai-oss-forks/tungstenite-rs\", rev = \"9200079d3b54a1ff51072e24d81fd354f085156f\" \\}")
                         ""))))
                  (add-after 'change-directory-to-rust-source 'fix-test
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
                      (substitute* (append (find-files "./*.rs"))
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
                         (string-append "\"command\": \"" (which "perl"))))))
                  (add-before 'build 'set-release-lto-to-thin
                    (lambda _
                      ;; Upstream uses fat LTO, which is prone to OOM in Cuirass.
                      (setenv "CARGO_PROFILE_RELEASE_LTO" "thin"))))))
    (home-page "https://github.com/openai/codex")
    (synopsis "Lightweight coding agent that runs in your terminal")
    (description "Lightweight coding agent that runs in your terminal")
    (license license:asl2.0)))
