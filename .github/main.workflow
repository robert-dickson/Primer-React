workflow "Primer Components Workflow" {
  on = "push"
  resolves = [
    "npm lint",
    "npm test",
    "publish to gpr",
    "deploy",
  ]
}

action "npm install" {
  uses = "actions/npm@v2.0.0"
  args = "ci"
}

action "npm lint" {
  uses = "actions/npm@v2.0.0"
  needs = ["npm install"]
  args = "run lint"
}

action "npm test" {
  uses = "actions/npm@v2.0.0"
  needs = ["npm install"]
  args = "test"
}

action "deploy" {
  uses = "primer/deploy@v3.0.0"
  needs = ["npm install"]
  secrets = ["GITHUB_TOKEN", "NOW_TOKEN"]
}

action "publish to gpr" {
  uses = "primer/publish@v1.0.0"
  needs = ["npm install"]
  env = {
    NPM_REGISTRY_URL = "https://npm.pkg.github.com",
  }
  secrets = ["GITHUB_TOKEN","NPM_AUTH_TOKEN"]
  args = ["--", "--unsafe-perm"]
}