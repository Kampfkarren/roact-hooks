# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Unreleased
### Fixed
- Fixed setState's parameter not being the state value when passing a callback to it.

## [0.2.0]
### Added
- Added validateProps component API option for hooked components. `validateProps(props) -> (false, message: string) | true`
- Added componentType component API option for hooked components. `componentType?: string`. Accepted strings are "Component" and "PureComponent".

### Fixed
- Current state is now provided to callback function when using `useState(function)`
- useMemo now supports tuple return values.

## [0.1.1]
### Fixed
- Fixed hook dependencies not registering updates.

## [0.1.0]
### Added
- Added `useState`.
- Added `useEffect`.
- Added `useContext`.
- Added `useValue`.
- Added `useMemo`.
- Added `useCallback`.
- Added `useBinding`.
- Added `useReducer`.
