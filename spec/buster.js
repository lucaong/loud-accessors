config = module.exports;

config["Browser tests"] = {
  env: "browser",
  rootPath: "../",
  libs: ["node_modules/eventspitter/lib/eventspitter.js"],
  sources: ["lib/loud-accessors.js"],
  tests: ["spec/**/*.spec.{coffee,js}"],
  extensions: [require("buster-coffee")]
}
