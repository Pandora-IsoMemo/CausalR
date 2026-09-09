# CausalR 26.09.0

## Updates
- Updated base image version and added additional package installations.
- Increased the required DataTools version to the most recent version.
- Expanded and organized .Rbuildignore, .gitignore, and .dockerignore entries to reduce accidental inclusion of local/CI/build artifacts.
- Added GitHub Actions workflows for `R CMD check` and `pkgdown` site building/deployment.
- Added `URL`, `BugReports` and `Depends` fields to `DESCRIPTION`.

# CausalR 25.04.0

## Updates
- Reduced package size by adding example files to the `.Rbuildignore`.
- Removed warning from import module.

# CausalR 24.06.1

## New Features
- Documentation for package functions has been added.

# CausalR 24.06.0

## New Features
- The Shiny app has been refactored into a package, enabling the app to be launched within a Docker container.
- Dependencies on other packages have been defined.
