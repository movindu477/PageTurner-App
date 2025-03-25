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

if (!$data || empty($data->email) || empty($data->password)) {
    echo json_encode(["status" => "error", "message" => "Invalid input"]);
    exit;
}

$email = $conn->real_escape_string($data->email);
$password = $data->password;

// Check if user exists
$query = "SELECT * FROM register WHERE email = '$email'";
$result = $conn->query($query);

if ($result->num_rows > 0) {
    $row = $result->fetch_assoc();
    $hashed_password = $row['password'];

    if (password_verify($password, $hashed_password)) {  // ✅ Secure password check
        echo json_encode([
            "status" => "success",
            "message" => "Login successful",
            "user" => [
                "id" => $row['id'],
                "name" => $row['name'],
                "email" => $row['email']
            ]
        ]);
    } else {
        echo json_encode(["status" => "error", "message" => "Incorrect password"]);
    }
} else {
    echo json_encode(["status" => "error", "message" => "User not found"]);
}

$conn->close();
?>