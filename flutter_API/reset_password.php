<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");

error_reporting(E_ALL);
ini_set('display_errors', 1);

$conn = new mysqli("localhost", "root", "", "flutter");

if ($conn->connect_error) {
    echo json_encode(["status" => "error", "message" => "Database connection failed: " . $conn->connect_error]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

if (!$data || empty($data->email) || empty($data->newPassword)) {
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
    exit;
}

$email = $conn->real_escape_string($data->email);
$newPassword = password_hash($data->newPassword, PASSWORD_BCRYPT); // Hash the new password

// Check if the email exists in the database
$query = "SELECT * FROM register WHERE email = '$email'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    // Update password
    $updateQuery = "UPDATE register SET password = '$newPassword' WHERE email = '$email'";
    if ($conn->query($updateQuery)) {
        echo json_encode(["status" => "success", "message" => "Password reset successful"]);
    } else {
        echo json_encode(["status" => "error", "message" => "Error updating password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}

$conn->close();
?>