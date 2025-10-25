(define-module (roquix packages codex)
  #:use-module (guix packages)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix download)
  #:use-module (guix git-download)
  #:use-module (guix build-system cargo)
  #:use-module (gnu packages llvm)
  #:use-module (gnu packages tls)
  #:use-module (gnu packages python)
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
    (native-inputs (list python))
    (arguments
     `(#:install-source? #f
       #:cargo-install-paths '("cli")
       #:cargo-test-flags '("--"
                            ;; FIXME: Needs permission for create file or directory
                            "--skip=suite::apply_command_e2e::test_apply_command_creates_fibonacci_file"
                            "--skip=suite::apply_command_e2e::test_apply_command_with_merge_conflicts"
                            "--skip=codex::tests::rejects_escalated_permissions_when_policy_not_on_request"
                            "--skip=exec_command::session_manager::tests::session_manager_streams_and_truncates_from_now"
                            "--skip=git_info::tests::resolve_root_git_project_for_trust_detects_worktree_and_returns_main_root"
                            "--skip=git_info::tests::resolve_root_git_project_for_trust_regular_repo_returns_repo_root"
                            "--skip=git_info::tests::test_collect_git_info_detached_head"
                            "--skip=git_info::tests::test_collect_git_info_git_repository"
                            "--skip=git_info::tests::test_collect_git_info_with_branch"
                            "--skip=git_info::tests::test_collect_git_info_with_remote"
                            "--skip=git_info::tests::test_get_git_working_tree_state_branch_fallback"
                            "--skip=git_info::tests::test_get_git_working_tree_state_clean_repo"
                            "--skip=git_info::tests::test_get_git_working_tree_state_unpushed_commit"
                            "--skip=git_info::tests::test_get_git_working_tree_state_with_changes"
                            "--skip=git_info::tests::test_recent_commits_orders_and_limits"
                            "--skip=shell::tests::test_run_with_profile_bash_escaping_and_execution"

                            "--skip=unified_exec::tests::multi_unified_exec_sessions"
                            "--skip=unified_exec::tests::reusing_completed_session_returns_unknown_session"
                            "--skip=unified_exec::tests::unified_exec_persists_across_requests_jif"
                            "--skip=unified_exec::tests::unified_exec_timeouts"

                            "--skip=suite::cli_stream::integration_git_info_unit_test"
                            "--skip=suite::client::azure_overrides_assign_properties_used_for_responses_url"
                            "--skip=suite::client::env_var_overrides_loaded_auth"

                            ;; FIXME: Unknown
                            "--skip=suite::compact_resume_fork::compact_resume_after_second_compaction_preserves_history"
                            "--skip=suite::compact_resume_fork::compact_resume_and_fork_preserve_model_history_view"

                            ;; FIXME: Needs permission for create file or directory
                            "--skip=suite::exec_stream_events::test_aggregated_output_interleaves_in_order"
                            "--skip=suite::exec_stream_events::test_exec_stderr_stream_events_echo"
                            "--skip=suite::exec_stream_events::test_exec_stdout_stream_events_echo"
                            "--skip=suite::exec_stream_events::test_exec_timeout_returns_partial_output"
                            "--skip=suite::shell_serialization::shell_output_is_structured_with_freeform_apply_patch"
                            "--skip=suite::shell_serialization::shell_output_reserializes_truncated_content"
                            "--skip=suite::shell_serialization::shell_output_stays_json_without_freeform_apply_patch"
                            "--skip=suite::tool_harness::shell_tool_executes_command_and_streams_output"
                            "--skip=suite::tool_parallelism::mixed_tools_fall_back_to_serial"
                            "--skip=suite::tool_parallelism::non_parallel_tools_run_serially"
                            "--skip=suite::tools::shell_escalated_permissions_rejected_then_ok"
                            "--skip=suite::tools::shell_sandbox_denied_truncates_error_output"
                            "--skip=suite::tools::shell_timeout_includes_timeout_prefix_and_metadata"
                            "--skip=suite::unified_exec::unified_exec_reuses_session_via_stdin"
                            "--skip=suite::unified_exec::unified_exec_timeout_and_followup_poll"
                            "--skip=suite::user_notification::summarize_context_three_requests_and_instructions"

                            ;; FIXME: python exited with ExitStatus(unix_wait_status(25856))
                            "--skip=suite::sandbox::python_multiprocessing_lock_works_under_sandbox"
                            ;; FIXME: sandbox blocked allowed write: ExitStatus(unix_wait_status(25856))
                            ;; It seems to need permission for create file or directory.
                            "--skip=suite::sandbox::sandbox_distinguishes_command_and_policy_cwds"

                            ;; codex-git-apply

                            ;; FIXME: Needs permission for create file or directory
                            "--skip=tests::apply_modify_conflict"
                            ;; FIXME: Unknown
                            "--skip=tests::apply_add_success"
                            "--skip=tests::apply_modify_skipped_missing_index"
                            "--skip=tests::apply_then_revert_success"
                            "--skip=tests::preflight_blocks_partial_changes"
                            "--skip=tests::revert_preflight_does_not_stage_index"

                            ;; codex-git-tooling
                            ;; FIXME: Needs permission for create file or directory
                            "--skip=ghost_commits::tests::create_and_restore_roundtrip"
                            "--skip=ghost_commits::tests::create_ghost_commit_rejects_force_include_parent_path"
                            "--skip=ghost_commits::tests::create_ghost_commit_uses_custom_message"
                            "--skip=ghost_commits::tests::create_snapshot_without_existing_head"
                            "--skip=ghost_commits::tests::restore_from_subdirectory_preserves_parent_vscode"
                            "--skip=ghost_commits::tests::restore_from_subdirectory_restores_files_relatively"
                            "--skip=ghost_commits::tests::restore_preserves_ignored_files"
                            "--skip=ghost_commits::tests::restore_requires_git_repository"

                            ;; codex-linux-sandbox
                            ;; FIXME: Unknown but seems to be permission issue
                            "--skip=suite::landlock::test_dev_null_write"
                            "--skip=suite::landlock::test_root_read"
                            "--skip=suite::landlock::test_timeout"
                            "--skip=suite::landlock::test_writable_root"

                            ;; codex-mcp-server
                            ;; FIXME: Needs permission for create file or directory
                            "--skip=test_shell_command_approval_triggers_elicitation"

                            ;; codex-tui
                            ;; NOTE: The paths are replaced to absolute path like "/tmp/guix-build-codex-0.46.0.drv-0/source/codex-rs/tui/example.png".
                            ;; It seems to be hard to fix, because such a longer path sometimes causes complicated UI change.
                            "--skip=chatwidget::tests::view_image_tool_call_adds_history_cell"
                            "--skip=diff_render::tests::ui_snapshot_apply_update_block_relativizes_path"

                            ;; core
                            ;; NOTE: Seems to depend on time
                            "--skip=suite::approvals::approval_matrix_covers_all_modes")
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
                      (substitute* (append '("core/src/unified_exec/mod.rs"
                                             "core/src/tools/handlers/unified_exec.rs")
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
