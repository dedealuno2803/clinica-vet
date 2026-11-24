<?php
require_once __DIR__ . "/../config/conexao.php";
require_once __DIR__ . "/../config/sessao.php";
exigir_login();

$id = (int)($_GET["id"] ?? 0);
if ($id > 0) {
    // Verifica vínculos antes de excluir (FK RESTRICT)
    $q = $conn->prepare("SELECT COUNT(*) c FROM pets WHERE tutor_id = ?");
    $q->bind_param("i", $id);
    $q->execute();
    $np = (int)$q->get_result()->fetch_assoc()["c"];

    $q2 = $conn->prepare("SELECT COUNT(*) c FROM agendamentos WHERE tutor_id = ?");
    $q2->bind_param("i", $id);
    $q2->execute();
    $na = (int)$q2->get_result()->fetch_assoc()["c"];

    if ($np > 0 || $na > 0) {
        header("Location: listar.php?msg=fk");
        exit;
    }
    $stmt = $conn->prepare("DELETE FROM tutores WHERE id = ?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
    header("Location: listar.php?msg=del");
    exit;
}
header("Location: listar.php");
exit;
