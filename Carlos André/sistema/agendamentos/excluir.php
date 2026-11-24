<?php
require_once __DIR__ . "/../config/conexao.php";
require_once __DIR__ . "/../config/sessao.php";
exigir_login();

$id = (int)($_GET["id"] ?? 0);
if ($id > 0) {
    $stmt = $conn->prepare("DELETE FROM agendamentos WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    header("Location: listar.php?msg=del");
    exit;
}
header("Location: listar.php");
exit;
