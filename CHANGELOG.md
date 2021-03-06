# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html). (Patch version X.Y.0 is implied if not specified.)

## [Unreleased]
### Added
- Add performance logging for report builder
- Add debug log statements
- Add additional try/catch error logging
- Enable logging of application
- Coveralls and jacoco plugin to pom
- coveralls/travis badging in readme.md
- Merged Docker config into repo

### Changed
- update to aqcu-framework version 0.0.6-SNAPSHOT

## [0.0.2] - 2019-02-20
### Added
- Added a default Aquarius timeout. 
- add specific timeout values

### Changed
- Disabled TLS 1.0/1.1 by default. 
- Updated to AQCU Framework 0.0.5. Cleaned up some warnings. 
- update SDK version to 18.8.1 
- data service calls

### Removed
- CorrectionListService
- FieldVisitDescriptionService
- GradeLookupService
- TimeSeriesDataCorrectedService
- TimeSeriesDescriptionListService

## [0.0.1] - 2018-09-24
### Added
- Initial release - happy path.
- CorrectionListService
- FieldVisitDescriptionService
- GradeLookupService
- TimeSeriesDataCorrectedService
- TimeSeriesDescriptionListService
- CorrectionsAtAGlanceRequestParameters
- CorrectionsAtAGlanceCorrections
- CorrectionsAtAGlanceFieldVisitDescription
- CorrectionsAtAGlanceReport
- CorrectionsAtAGlanceReportMetadata
- TimeSeriesCorrectedData
- CorrectionsAtAGlanceReportBuilderService

[Unreleased]: https://github.com/USGS-CIDA/aqcu-ext-report/compare/aqcu-corr-report-0.0.2...master
[0.0.2]: https://github.com/USGS-CIDA/aqcu-ext-report/compare/aqcu-corr-report-0.0.1...aqcu-corr-report-0.0.2
