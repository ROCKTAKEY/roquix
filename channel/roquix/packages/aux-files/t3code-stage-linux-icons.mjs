import * as NodeServices from "@effect/platform-node/NodeServices";
import * as Effect from "effect/Effect";
import { resolveDesktopBuildIconAssets, stageLinuxIcons } from "./build-desktop-artifact.ts";

await Effect.runPromise(
  stageLinuxIcons(
    "apps/desktop/resources",
    resolveDesktopBuildIconAssets(process.argv[2]).linuxIconPng,
    false,
  ).pipe(Effect.provide(NodeServices.layer), Effect.scoped),
);
