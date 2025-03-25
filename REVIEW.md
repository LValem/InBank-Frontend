This review covers the updated implementation of the loan application frontend (`TICKET-101`) and explains how and why
the frontend was adjusted to better reflect the assignment requirements and improve usability and maintainability.

**What Was Good in the Original Implementation**
Before applying any changes, the original frontend showed several good practices and structural decisions:

- Good UI/UX Foundation: The loan form was implemented with meaningful visual spacing, sliders, and labels, providing
  a clean user interface for loan application.
- Input Validation: National ID validation was already built in using a TextFormField with custom formatting and
  validation logic.
- Logical State Management: A StatefulWidget was used for the form with state variables for each major data point:
  personal code, loan amount, loan period, and results.
- Separation of Concerns: The ApiService class handled API logic cleanly, keeping UI code focused.

These established a solid baseline and helped guide where improvements were needed.

---

## Issues Identified in Original Code.

### 1. Request Auto-submission on Input ChangeProblem:
In the original version, every change in the national ID, loan amount, or loan period automatically triggered a
request to the backend. This caused excessive API calls, unnecessary server load, and a poor user experience.

Fix:
Disabled auto-submission and introduced a Submit button instead. Users now review their input and explicitly submit
the form.

---

### 2. Logic for Adjusted Loans Was InvertedProblem:
The UI showed the user's original input instead of reflecting backend adjustments when the approved loan differed from
the requested one. The logic compared loan result values to the input in a confusing way.

Fix:
- Reworked _submitForm to store the original loan input values.
- Compared result values to original values and updated the sliders to reflect the final approved values.
- If adjustments were made, a note is shown: "Note: Your request was adjusted for approval."

---

### 3. Input Consistency and Validation HandlingProblem:
When invalid input was detected, the error handling reset results but did not display consistent validation feedback.
Fix:
- Improved error message visibility and layout.
- Ensured that error messages reset only the result section, not the user input.
- Added an "awaiting input" fallback state.

---

### 4. Max Period Value IncorrectProblem:
Original code allowed loan periods up to 60 months, but the backend was adjusted to 48 months, seemed unnecessary to
even give the option to calculate loan over the max allowed period so changing the max to 48 is like a double check,
backend mostly checks the inputs but added frontend check just in case.
Fix:
- Changed slider max value to 48.
- Updated the label at the bottom of the slider to reflect this.

---

### 5. Backend Code Review

**Continues in the backend repo**
https://github.com/LValem/InBank-Backend/blob/main/REVIEW.md

---
