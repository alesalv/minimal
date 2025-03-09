## 2.0.0

* Document minimal manager
* Remove minimal state (breaking change), easing notifiers with primitives
* Improve MMMNotifier notify()
* Improve internal value notifier for selection
* Make selection read-only (breaking change)

## 1.0.5 (retracted)

* Document minimal manager
* Remove minimal state (breaking change), easing notifiers with primitives
* Improve MMMNotifier notify()
* Improve internal value notifier for selection
* Make selection read-only

## 1.0.4

* Deploy web example to GitHub Pages upon publishing
* Update README.md about web example
* Add package version on example main page

## 1.0.3

* Add pub and license badges to README.md
* Rename morphing example to chroma counter
* Add override() method to MMManager for testing purposes
* Add test for chroma counter widget using mocked notifier

## 1.0.2

* Expose a check for notifier been disposed
* Test when notifier is accessed after disposal
* Improve README.md
* Improve pubspec.yaml

## 1.0.1

* Fix logo URL in README.md

## 1.0.0

* Initial release of Minimal state management package
* Features:
  * MVN (Model-View-Notifier) pattern
  * Lazy initialization of notifiers
  * Optional autodispose for notifiers
  * State selection for optimized rebuilds
  * Dependency injection with locator
