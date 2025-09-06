# DKSN Calendar

[![style: very good analysis][very_good_analysis_badge]][very_good_analysis_link]
[![Powered by Mason](https://img.shields.io/endpoint?url=https%3A%2F%2Ftinyurl.com%2Fmason-badge)](https://github.com/felangel/mason)
[![License: MIT][license_badge]][license_link]

A powerful and customizable Flutter calendar widget that supports both monthly and weekly views with extensive theming options.

## Screenshots 📱

<table>
  <tr>
    <td align="center">
      <img src="images/Screenshot 2025-09-06 142315.png" width="300" alt="Monthly View"/>
      <br/>
      <b>Monthly View</b>
    </td>
    <td align="center">
      <img src="images/Screenshot 2025-09-06 142426.png" width="300" alt="Weekly View"/>
      <br/>
      <b>Weekly View</b>
    </td>
  </tr>
</table>

## Features ✨

- 📅 **Monthly View** - Display a full month calendar grid
- 📆 **Weekly View** - Show a single week view
- 🎨 **Customizable Themes** - Extensive theming options for all calendar components
- 🎯 **Date Selection** - Built-in date selection and navigation
- 🛠️ **Custom Builders** - Custom day and header builders for maximum flexibility
- 📱 **Responsive Design** - Works beautifully on all screen sizes
- 🧪 **Well Tested** - Comprehensive test coverage

## Installation 💻

Add `dksn_calendar` to your `pubspec.yaml`:

```yaml
dependencies:
  dksn_calendar: ^0.1.0
```

Then run:

```sh
flutter pub get
```

## Quick Start 🚀

Import the package:

```dart
import 'package:dksn_calendar/dksn_calendar.dart';
```

### Basic Usage

```dart
class MyCalendarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar')),
      body: DksnCalendar(),
    );
  }
}
```

### With Controller

```dart
class MyCalendarPage extends StatefulWidget {
  @override
  _MyCalendarPageState createState() => _MyCalendarPageState();
}

class _MyCalendarPageState extends State<MyCalendarPage> {
  late DksnCalendarController _controller;

  @override
  void initState() {
    super.initState();
    _controller = DksnCalendarController(
      DksnCalendarType.monthly,
      DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Calendar with Controller')),
      body: Column(
        children: [
          DksnCalendar(controller: _controller),
          DropdownButton<DksnCalendarType>(
            value: _controller.type,
            items: DksnCalendarType.values.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type.name),
              );
            }).toList(),
            onChanged: (type) {
              if (type != null) {
                setState(() {
                  _controller.setType(type);
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
```

## Advanced Usage 🎨

### Custom Theme

```dart
DksnCalendar(
  theme: DksnCalendarTheme(
    monthly: DksnCalendarMonthlyTheme(
      dayBuilder: (currentDate, selectedDate, date) {
        final isSelected = date.day == selectedDate?.day &&
                          date.month == selectedDate?.month &&
                          date.year == selectedDate?.year;
        
        return Container(
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '${date.day}',
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    ),
  ),
)
```

### With Custom Header

```dart
DksnCalendar(
  controller: _controller,
  theme: DksnCalendarTheme(
    header: DksnCalendarHeaderTheme(
      headerBuilder: (context, date, onPrevious, onNext) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPrevious,
                icon: Icon(Icons.chevron_left),
              ),
              Text(
                DateFormat('MMMM yyyy').format(date),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: onNext,
                icon: Icon(Icons.chevron_right),
              ),
            ],
          ),
        );
      },
    ),
  ),
)
```

## API Reference 📖

### DksnCalendar

The main calendar widget.

| Property | Type | Description |
|----------|------|-------------|
| `controller` | `DksnCalendarController?` | Controls the calendar state and behavior |
| `theme` | `DksnCalendarTheme?` | Custom theme for styling the calendar |
| `initialType` | `DksnCalendarType?` | Initial calendar view type (monthly/weekly) |

### DksnCalendarController

Controls the calendar behavior and state.

| Method | Description |
|--------|-------------|
| `setType(DksnCalendarType type)` | Switch between monthly and weekly views |
| `selectDate(DateTime date)` | Select a specific date |
| `goToNext()` | Navigate to next month/week |
| `goToPrevious()` | Navigate to previous month/week |

### DksnCalendarType

Enum for calendar view types:
- `DksnCalendarType.monthly` - Monthly grid view
- `DksnCalendarType.weekly` - Weekly list view

## Example 💡

Check out the [example](example/) directory for a complete working example demonstrating all features of the DKSN Calendar.

To run the example:

```sh
cd example
flutter run
```

## Testing 🧪

This package comes with comprehensive tests. To run the tests:

```sh
flutter test
```

For coverage report:

```sh
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## Contributing 🤝

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Setup

1. Fork the repository
2. Clone your fork: `git clone https://github.com/your-username/dksn_calendar.git`
3. Create a feature branch: `git checkout -b feature/my-new-feature`
4. Install dependencies: `flutter pub get`
5. Make your changes
6. Run tests: `flutter test`
7. Commit your changes: `git commit -am 'Add some feature'`
8. Push to the branch: `git push origin feature/my-new-feature`
9. Submit a pull request

### Code Style

This project uses [Very Good Analysis](https://pub.dev/packages/very_good_analysis) for consistent code style. Please ensure your code follows the established patterns.

## Changelog 📝

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes.

## License 📄

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support 💬

If you like this package, please consider:
- ⭐ Starring the repository
- 🐛 Reporting issues
- 📝 Contributing improvements
- 💝 Sponsoring the project

---

**Made with ❤️ by the Flutter community**

[flutter_install_link]: https://docs.flutter.dev/get-started/install
[github_actions_link]: https://docs.github.com/en/actions/learn-github-actions
[license_badge]: https://img.shields.io/badge/license-MIT-blue.svg
[license_link]: https://opensource.org/licenses/MIT
[logo_black]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_black.png#gh-light-mode-only
[logo_white]: https://raw.githubusercontent.com/VGVentures/very_good_brand/main/styles/README/vgv_logo_white.png#gh-dark-mode-only
[mason_link]: https://github.com/felangel/mason
[very_good_analysis_badge]: https://img.shields.io/badge/style-very_good_analysis-B22C89.svg
[very_good_analysis_link]: https://pub.dev/packages/very_good_analysis
[very_good_cli_link]: https://pub.dev/packages/very_good_cli
[very_good_coverage_link]: https://github.com/marketplace/actions/very-good-coverage
[very_good_ventures_link]: https://verygood.ventures
[very_good_ventures_link_light]: https://verygood.ventures#gh-light-mode-only
[very_good_ventures_link_dark]: https://verygood.ventures#gh-dark-mode-only
[very_good_workflows_link]: https://github.com/VeryGoodOpenSource/very_good_workflows
