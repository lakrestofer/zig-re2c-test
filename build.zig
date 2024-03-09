const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // build options
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // == generate tokenizer begin ==
    const generate_tokenizer_command = b.addSystemCommand(&.{"re2c"});
    generate_tokenizer_command.addArgs(&.{"--utf8"});
    generate_tokenizer_command.addFileArg(.{ .path = "./src-c/tokenizer_sm.in.c" });
    generate_tokenizer_command.addArgs(&.{"--output"});
    const generated_tokenizer = generate_tokenizer_command.addOutputFileArg("tokenizer_sm.c");
    const gen_write_files = b.addWriteFiles();
    gen_write_files.addCopyFileToSource(generated_tokenizer, "src-c/tokenizer_sm.c");
    // == generate tokenizer end ==

    // == build tokenizer begin ==
    const tokenizer_lib = b.addStaticLibrary(.{ .name = "tokenizer_sm", .target = target, .optimize = optimize });
    tokenizer_lib.linkLibC();
    tokenizer_lib.addCSourceFiles(.{
        .files = &.{"src-c/tokenizer_sm.c"},
        .flags = &.{ "-pedantic", "-Wall" },
    });
    tokenizer_lib.addIncludePath(.{ .path = "src-c/" });
    tokenizer_lib.step.dependOn(&gen_write_files.step);
    b.installArtifact(tokenizer_lib);
    // == build tokenizer end

    // == build exe begin ==
    const exe = b.addExecutable(.{
        .name = "zig-re2c-test",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe.linkLibC();
    exe.linkLibrary(tokenizer_lib);
    exe.addIncludePath(.{ .path = "src-c/" });
    b.installArtifact(exe);
    // == build exe end ==

    // == build commands ==
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // == build tests begin ==
    const exe_unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });
    exe_unit_tests.addIncludePath(.{ .path = "src-c/" });
    exe_unit_tests.linkLibrary(tokenizer_lib);
    const run_exe_unit_tests = b.addRunArtifact(exe_unit_tests);
    // == build tests end ==

    // == define steps begin ==
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_exe_unit_tests.step);

    const generate_lexer_step = b.step("genlex", "generate the lexer");
    generate_lexer_step.dependOn(&gen_write_files.step);

    const build_lexer_step = b.step("buildlex", "build the lexer");
    build_lexer_step.dependOn(&tokenizer_lib.step);
    // == define steps end ==
}
