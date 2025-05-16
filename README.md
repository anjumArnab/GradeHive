# GradeHive

GradeHive is a lightweight Flutter app that uses **Google Sheets** as a backend database, with **Google Apps Script** providing a RESTful API interface.  
This project demonstrates how to build a simple CRUD (Create, Read, Update, Delete) app by leveraging Google Sheets for data storage and Google Apps Script as the backend service.

## Technology Stack

- **Flutter**: Client-side app for UI and API communication
- **Google Sheets**: Cloud spreadsheet database for student records
- **Google Apps Script**: Backend REST API layer deployed as a Web App
- **JSON**: Data exchange format between Flutter and Apps Script

---

## Important Notes on CORS

- **Google Apps Script does not allow setting custom headers like `Access-Control-Allow-Origin` directly.**
- **CORS is handled automatically** when you deploy your script as a web app with the access set to:
  > **Execute as:** Me (your account)  
  > **Who has access:** Anyone, even anonymous
- Your Flutter web app can send POST requests directly without needing extra CORS headers in the script.

---

## Full `code.gs` Script

```javascript
const SHEET_NAME = "Students";

// GET request handler - GET not supported
function doGet(e) {
  return ContentService.createTextOutput("GET not supported. Use POST.")
    .setMimeType(ContentService.MimeType.TEXT);
}

// OPTIONS preflight handler for CORS
function doOptions(e) {
  // Return empty response, no headers needed
  return ContentService.createTextOutput("");
}

// POST request handler
function doPost(e) {
  try {
    const data = JSON.parse(e.postData.contents);
    const action = data.action;

    const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(SHEET_NAME);
    if (!sheet) {
      return createResponse({ error: "Sheet not found" });
    }

    let result;
    switch (action) {
      case "create":
        result = createStudent(sheet, data);
        break;
      case "read":
        result = readStudents(sheet);
        break;
      case "update":
        result = updateStudent(sheet, data);
        break;
      case "delete":
        result = deleteStudent(sheet, data);
        break;
      default:
        result = { error: "Invalid action" };
    }

    return createResponse(result);

  } catch (err) {
    return createResponse({ error: err.toString() });
  }
}

// Helper to create JSON response
function createResponse(data) {
  return ContentService.createTextOutput(JSON.stringify(data))
    .setMimeType(ContentService.MimeType.JSON);
}

// Create student
function createStudent(sheet, data) {
  sheet.appendRow([data.name, data.age, data.grade]);
  return { success: true, message: "Student created", data: data };
}

// Read all students
function readStudents(sheet) {
  const rows = sheet.getDataRange().getValues();
  const headers = rows[0];
  const students = [];

  for (let i = 1; i < rows.length; i++) {
    let row = rows[i];
    let student = {};
    for (let j = 0; j < headers.length; j++) {
      student[headers[j]] = row[j];
    }
    student["row"] = i + 1; // Keep track of row number for updates/deletes
    students.push(student);
  }

  return { success: true, data: students };
}

// Update student by row number
function updateStudent(sheet, data) {
  const row = data.row;
  sheet.getRange(row, 1, 1, 3).setValues([[data.name, data.age, data.grade]]);
  return { success: true, message: "Student updated", data: data };
}

// Delete student by row number
function deleteStudent(sheet, data) {
  const row = data.row;
  sheet.deleteRow(row);
  return { success: true, message: "Student deleted", row: row };
}


