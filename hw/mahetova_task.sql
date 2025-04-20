/*
  Автор: Махетова Ольга
  Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

-- Создание платежа
declare
  c_status_created constant number(22, 10) := 0;
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Платеж создан. Статус: ' || c_status_created;
begin
	dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd mon year'));
	dbms_output.put_line(v_msg);
end;
/

-- Сброс платежа в "ошибочный статус" с указанием причины
declare
  c_status_error constant number(22, 10) := 2;
  v_date date := sysdate;
  v_reason varchar2(50) := 'недостаточно средств';
  v_msg varchar2(250 char) := 'Сброс платежа в "ошибочный статус" с указанием причины. Статус: ' || c_status_error || '. Причина: ' || v_reason;
begin
	dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd FMmonth (dy)'));
	dbms_output.put_line(v_msg);
end;
/

-- Отмена платежа с указанием причины
declare
  c_status_canceled constant number(22, 10) := 3;
  v_date date := sysdate;
  v_reason varchar2(50) := 'ошибка пользователя';
  v_msg varchar2(250 char) := 'Отмена платежа с указанием причины. Статус: ' || c_status_canceled || '. Причина: ' || v_reason;
begin
	dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.FMRM.yyyy'));
	dbms_output.put_line(v_msg);
end;
/

-- Успешное завершение платежа
declare
  c_status_finished constant number(22, 10) := 1;
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Успешное завершение платежа. Статус: ' || c_status_finished;
begin
	dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yy hh24:mi:ss'));
	dbms_output.put_line(v_msg);
end;
/

-- Данные платежа добавлены или обновлены
declare
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
begin
	dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yyyy hh:mi AM'));
	dbms_output.put_line(v_msg);
end;
/

-- Детали платежа удалены
declare
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Детали платежа удалены по списку id_полей';
begin
	dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'DDD') || '''s day of year');
	dbms_output.put_line(v_msg);
end;
/
