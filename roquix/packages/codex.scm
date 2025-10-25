(define-module (roquix packages codex)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
  #:use-module (gnu packages version-control)
  #:use-module (rustup build toolchain))

(define-public codex
  (package
    (name "codex")
    (version "0.48.0")
    (source
     (origin
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/openai/codex/")
             (commit (string-append "rust-v" version))))
       (file-name (git-file-name name version))
       (sha256
        (base32 "1m6ca4z8kdc00xvfsh25pzywhd1n44xf92r7p96hg8qfj8q3a8ba"))))
    ;; TODO: Use official rust-1.89.0 when the official guix channel is updated
    (build-system (make-cargo-build-system "1.89.0"))
    (inputs (cons* clang-toolchain openssl
                   (cargo-inputs 'codex
                                 #:module '(roquix packages rust-crates))))
    ;; Need for tests
    (native-inputs (list python git))
    (arguments
     `(#:install-source? #f
       #:cargo-install-paths '("cli")
       #:cargo-test-flags '("--"
                            ;; core
                            ;; FIXME: There are objects in the response that are either excessive or missing.
                            "--skip=suite::compact_resume_fork::compact_resume_after_second_compaction_preserves_history" ; "hello world" message is missing
                            "--skip=suite::compact_resume_fork::compact_resume_and_fork_preserve_model_history_view" ; "hello world" message is excessive

                            ;; NOTE: Seems to depend on time
                            "--skip=suite::approvals::approval_matrix_covers_all_modes"

                            ;; FIXME: python exited with ExitStatus(unix_wait_status(25856))
                            "--skip=suite::sandbox::python_multiprocessing_lock_works_under_sandbox"
                            "--skip=suite::sandbox::sandbox_distinguishes_command_and_policy_cwds"

                            ;; linux-sandbox
                            ;; FIXME: The kernel must support landlock feature to run these tests.
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
                            ;; FIXME: Unknown error occur in cuirass
                            ;; thread 'suite::codex_message_processor_flow::test_codex_jsonrpc_conversation_flow' panicked at app-server/tests/suite/codex_message_processor_flow.rs:148:6:
                            ;; task_finished_notification resp: unexpected JSONRPCMessage::Request: Request(JSONRPCRequest { id: Integer(0), method: "execCommandApproval", params: Some(Object {"conversationId": String("019a1bf7-6bce-7371-b2a7-c9319d5d5c0d"), "callId": String("call1234"), "command": Array [String("ls")], "cwd": String("/tmp/guix-build-codex-0.48.0.drv-0/.tmpiAoxpP/workdir"), "reason": String("command failed; retry without sandbox?"), "parsedCmd": Array [Object {"type": String("list_files"), "cmd": String("ls"), "path": Null}]}) })
                            ;; note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
                            "--skip=suite::codex_message_processor_flow::test_codex_jsonrpc_conversation_flow"
)
       #:phases (modify-phases %standard-phases
                  (add-after 'unpack 'change-directory-to-rust-source
                    (lambda _
                      (chdir "codex-rs")))
                  (add-after 'change-directory-to-rust-source 'use-guix-vendored-dependencies
                    (lambda _
                      (substitute* "Cargo.toml"
                        (("ratatui = \\{ git = \"https://github.com/nornagon/ratatui\", branch = \"nornagon-v0.29.0-patch\" \\}")
                         ""))))
                  (add-after 'use-guix-vendored-dependencies 'fix-test
                    (lambda _
                      ;; Tese tests need environments variable named USER.
                      ;; - suite::client::azure_overrides_assign_properties_used_for_responses_url
                      ;; - suite::client::env_var_overrides_loaded_auth
                      (setenv "USER" "guix")

                      ;; NOTE: The version is always 0.0.0 in the original Cargo.toml,
                      ;; but cargo-build-system generates theirs, where the version is package version.
                      (substitute* '("app-server/tests/suite/user_agent.rs"
                                     "mcp-server/tests/common/mcp_process.rs")
                        (("codex_cli_rs/0\\.0\\.0")
                         ,(string-append "codex_cli_rs/" version))
                        ;; NOTE: Don't replace "0.0.0" because a version in client_info is also "0.0.0".
                        ;; Replace only server info.
                        (("\"version\": \"0.0.0\",")
                         ,(string-append "\"version\": \"" version "\",")))
                      ;; NOTE: Replace version string in snapshot
                      (let ((trailing-whitespace-length 17))
                        (substitute* (find-files "tui/src/status/snapshots/"
                                                 ".*\\.snap")
                          (((string-append "OpenAI Codex \\(v0\\.0\\.0\\)"
                                           (make-string
                                            trailing-whitespace-length #\space)))
                           (string-append "OpenAI Codex (v"
                                          ,version ")"
                                          ;; NOTE: Length of whitespace should be adjusted for TUI frame
                                          (make-string (+
                                                        trailing-whitespace-length
                                                        (- (string-length
                                                            "0.0.0")
                                                           (string-length ,version)))
                                                       #\space)))))
                      (substitute* (append (find-files "core/src/")
                                           (find-files "core/tests/suite/"))
                        (("/bin/sh")
                         (which "sh"))
                        (("/bin/bash")
                         (which "bash"))
                        (("/bin/echo")
                         (which "echo"))
                        (("/bin/cat")
                         (which "cat"))))))))
    (home-page "https://github.com/openai/codex")
    (synopsis "Lightweight coding agent that runs in your terminal")
    (description "Lightweight coding agent that runs in your terminal")
    (license license:asl2.0)))
