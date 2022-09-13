# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.0]
### Added
- Added Luau types to Hooks API ([#36](https://github.com/Kampfkarren/roact-hooks/pull/36))

## [0.4.1]
### Fixed
- Fixed `useMemo` not working correctly with nil dependencies ([#35](https://github.com/Kampfkarren/roact-hooks/issues/35))

## [0.4.0]
### Added
- Provide Roact instance in hooks argument (#28)

### Fixed
- Fix useContext for uninitialized and/or changing contexts (#26)
- `useMemo` now computes a new value every render if no array is provided (#29)
- Fixed `useEffect` not running when a dependency changes to nil (#32)

## [0.3.0]
### Changed
- `useEffect` now call its unmount function when its dependencies change, just like React hooks.
- `useState` will now cache default values, meaning `useState(math.random)` will no longer give a new default value every time.
- `useState` with a default parameter will now call the function without parameters, rather than with 1 nil parameter. This caused problems with `useState(math.random)`, as `math.random()` is valid, but `math.random(nil)` is not.

### Fixed
- `useState` will now properly pass in default values when giving a callback to the set function, rather than passing in nil.

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
