### Issue: CI/CD Job Failure

The CI/CD job failed due to a mismatch in the required Babel version. The required version is "^7.16.0", but the installed version is "7.12.3".

### Solution:
1. Update Babel dependencies in `frontend/package.json` to "^7.16.0" or higher.
2. Reinstall node modules.
3. Verify the build.

### Reference:
- CI/CD Job: [Job Link](https://github.com/shinyay/legacy-spring-boot-23-app/actions/runs/16471400060/job/46561381565)
- Affected File: `frontend/package.json` @ [6206fce](https://github.com/shinyay/legacy-spring-boot-23-app/blob/6206fce/frontend/package.json)