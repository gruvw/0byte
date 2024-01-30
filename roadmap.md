# Roadmap

## Alpha release `v0.0.1-alpha.1`

No support for bookmarking, no data persistence, basic data validation

- [X] Data input form (text to input first value) (keyboard digit row ?)
- [X] Add entry
- [X] Edit entry (number or rename)
- [X] Delete entry
- [X] Change conversion target
- [X] Change target size
- [X] Arbitrary large number conversion
- [X] Handle scrolling
- [X] Color data prefix
- [X] Testing of conversion

## Beta release `v0.0.1-beta`

Improving user input

- [X] Data input validation (+ alphabet verification & hex to maj & no sign if not signed decimal input/ascii, subtitle not empty, not only sign alone)
- [X] Handle entries UI overflow (middle), **converted to issue**
- [X] Reorder entries
- [X] UI collection related operation (edit label, create collection, list collections, collection title)
- [X] Collection related attributes (N, target type)
- [X] Create Logo + integration
- [X] Splash screen
- [X] Copy values on long click
- [X] Responsive Conversion
- [X] TextFields submit on focus loss

## Alpha release `v0.0.2-alpha.1`

Persistence support

- [X] Support saving/bookmarking (non-empty) pages
- [X] Fix moving entry color #2
- [X] Style popup forms
- [X] Add Hive database support
- [X] List saved pages (title) on hamburger menu

## Alpha release `v0.0.2-alpha.2`

Sharing

- [X] Import & export pages
- [X] Share single page
- [X] Collection to clipboard
- [X] Invalid inputs starting with correct prefix (case insensitive) are automatically converted (easier copy paste)

## Alpha release `v0.0.2-alpha.3`

Improving UX + code architecture

- [X] Settings
  - [X] Support number separator
  - [X] Display separator + Clipboard separator to settings (settings page)
  - [X] Option: to copy ASCII Unicode Control Pictures vs ASCII values
  - [X] Option: Always trim leading 0s on converted
  - [X] Persistent settings
- [X] Full UX redesign (no more fixed output per collection)
  - [X] Patch entry and collections to support new features (+ needed corrections)
  - [X] Finish entry page
  - [X] Finish refactor (pages, no longer used classes, new types, new entry, extract constants, ...)
  - [X] Fix outlined buttons hover color
- [ ] Fix web issues (cross-browser, mobile errors)
- [X] Fix UI (scaling, font, responsive)
  - [X] Fix android keyboard comes and moves UI (entry page)
- [ ] Fix https://github.com/gruvw/0byte/issues/1
- [X] Fix https://github.com/gruvw/0byte/issues/4
- [X] Fix https://github.com/gruvw/0byte/issues/5
- [X] Fix https://github.com/gruvw/0byte/issues/6
- [X] Extract style from structure (theme)
- [X] Link to github repository in app
- [X] Splash screen logo

## Beta release `v0.0.2-beta`

Usability polish

- [ ] Support base 64 conversions
- [ ] Support Latin-1/ISO 8859-1
- [ ] Support Octal conversion
- [ ] Help menu (displaying possible prefixes, alphabets (hex to maj), explain data validation, explain conversion process, app infos and versions, long press to copy (features), local data/no server -> exports)
- [ ] FIXMEs and TODOs
- [ ] Write README (features + screenshots)

## Major release `v0.0.3`

Cross-Compatibility

- [ ] Application website with download links (+ support)
- [ ] Test android
- [ ] Test Linux
- [ ] Test Windows
- [ ] Test WEB (all browsers, mobile)
- [ ] (Test IOS, MAC ?)

## Further Ideas

1. Light theme support
2. Key-maps (shortcuts) for keyboard only use (on desktop and web)
3. Enable application wide undo (redo)
4. Multiple conversion targets per entry
5. Custom keyboard for data input
