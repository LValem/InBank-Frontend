# InBank Frontend

This project is a frontend application for the InBank loan application service.
It is built using Flutter and communicates with the backend API to
display loan options and handle loan applications.

## Technologies Used
- Flutter 3.19.5
- Dart 3.3.3

## Installing Flutter
Running the application requires having Flutter installed.
It can be installed by following the instructions in the
[Flutter documentation](https://docs.flutter.dev/get-started/install) for the Web.

Quick links:
- [Windows installation](https://docs.flutter.dev/get-started/install/windows/web#install-the-flutter-sdk)
- [Linux installation](https://docs.flutter.dev/get-started/install/linux/web)
- [MacOS installation](https://docs.flutter.dev/get-started/install/macos/web)

You can verify your installation by running `flutter doctor`

## Running the application
To run the application, follow these steps:

1. Clone the repository.
2. Navigate to the root directory of the project.
3. Run `flutter pub get` to install the required dependencies.
4. Run `flutter run` to start the application in debug mode.

## Functionality

The InBank Frontend application provides a form for submitting loan applications. Users can:

- Select their country (Estonia 🇪🇪, Latvia 🇱🇻, or Lithuania 🇱🇹).
- Enter their national ID number.
- Adjust the desired loan amount and loan period using sliders.
- Submit the application and see either:
    - The approved loan amount and period (which may be adjusted by backend rules),
    - Or a helpful error message if their request is not valid.

---

## Features

### Country Selection
- Users must select a country before submitting an application.
- Country selection is done via clickable flag icons.
- The backend uses the selected country to apply age validation rules.

### Adjustments
- The frontend compares approved loan values with the user's requested values.
- If the approved loan is adjusted, the frontend shows a helpful note:
  > _"Note: Your request was adjusted for approval."_

### Validations
- Basic client-side validation ensures the ID is 11 digits long.
- The backend performs full validation, including age and value constraints.
- Errors are clearly shown, and users can fix inputs and resubmit.

---

## Components

### LoanForm
Displays the full loan application form including:
- National ID input
- Loan amount slider (from 2000€ to 10000€)
- Loan period slider (from 12 to 48 months)
- Submit button
- Displays backend responses and errors

Takes a `selectedCountry` prop from the parent and uses it in the API call.

### ApiService
The ApiService component provides methods for making API calls to the backend API.
It sends loan application information to the backend API and receives a response
with the approved loan amount and loan period.
