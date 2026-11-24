<?php
require_once __DIR__ . "/../config/conexao.php";
require_once __DIR__ . "/../config/sessao.php";
exigir_login();

$id = (int)($_GET["id"] ?? 0);
if ($id > 0) {
    $q = $conn->prepare("SELECT COUNT(*) c FROM agendamentos WHERE pet_id = ?");
    $q->bind_param("i", $id);
    $q->execute();
    $na = (int)$q->get_result()->fetch_assoc()["c"];
    if ($na > 0) {
        header("Location: listar.php?msg=fk");
        exit;
    }
    $stmt = $conn->prepare("DELETE FROM pets WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    header("Location: listar.php?msg=del");
    exit;
}
header("Location: listar.php");
exit;
