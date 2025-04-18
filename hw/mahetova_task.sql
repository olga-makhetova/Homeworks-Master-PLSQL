/*
  Автор: Махетова Ольга
  Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

-- Создание платежа
declare
  c_status_created constant number := 0;
  v_msg varchar2(250) := 'Платеж создан. Статус: ' || c_status_created;
begin
	dbms_output.put_line(v_msg);
end;
/

-- Сброс платежа в "ошибочный статус" с указанием причины
declare
  c_status_error constant number := 2;
  v_reason varchar2(50) := 'недостаточно средств';
  v_msg varchar2(250) := 'Сброс платежа в "ошибочный статус" с указанием причины. Статус: ' || c_status_error || '. Причина: ' || v_reason;
begin
	dbms_output.put_line(v_msg);
end;
/

-- Отмена платежа с указанием причины
declare
  c_status_canceled constant number := 3;
  v_reason varchar2(50) := 'ошибка пользователя';
  v_msg varchar2(250) := 'Отмена платежа с указанием причины. Статус: ' || c_status_canceled || '. Причина: ' || v_reason;
begin
	dbms_output.put_line(v_msg);
end;
/

-- Успешное завершение платежа
declare
  c_status_finished constant number := 1;
  v_msg varchar2(250) := 'Успешное завершение платежа. Статус: ' || c_status_finished;
begin
	dbms_output.put_line(v_msg);
end;
/

-- Данные платежа добавлены или обновлены
declare
  v_msg varchar2(250) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
begin
	dbms_output.put_line(v_msg);
end;
/

-- Детали платежа удалены
declare
  v_msg varchar2(250) := 'Детали платежа удалены по списку id_полей';
begin
	dbms_output.put_line(v_msg);
end;
/
