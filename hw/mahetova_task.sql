/*
  Автор: Махетова Ольга
  Описание скрипта: API для сущностей “Платеж” и “Детали платежа”
*/

-- Создание платежа
declare
  c_status_created constant payment.status%type := 0;
  v_payment_id payment.payment_id%type := 0;
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Платеж создан. Статус: ' || c_status_created;
	v_payment_data t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE_1'),
																																	t_payment_detail(2, 'IP_1'),
																																	t_payment_detail(3, 'NOTE_1'),
																																	t_payment_detail(4, 'IS_CHECKED_FRAUD_1')
																																	);
begin
  dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd mon year'));
  dbms_output.put_line(v_msg);

  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  
  if v_payment_data is not empty then
    for i in v_payment_data.first..v_payment_data.last loop
    	if v_payment_data(i).field_type is null then
    	  dbms_output.put_line('ID поля не может быть пустым');
    	end if;
    	if v_payment_data(i).field_value is null then
    	  dbms_output.put_line('Значение в поле не может быть пустым');
    	end if;
  	  dbms_output.put_line('field_type = ' || v_payment_data(i).field_type || ', field_value = ' || v_payment_data(i).field_value );
    end loop;
  else
    dbms_output.put_line('Коллекция не содержит данных');
  end if;
end;
/

-- Сброс платежа в "ошибочный статус" с указанием причины
declare
  c_status_error constant payment.status%type := 2;
  v_payment_id payment.payment_id%type := 0;
  v_date date := sysdate;
  v_reason payment.status_change_reason%type := 'недостаточно средств';
  v_msg varchar2(250 char) := 'Сброс платежа в "ошибочный статус" с указанием причины. Статус: ' || c_status_error || '. Причина: ' || v_reason;
begin
  dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd FMmonth (dy)'));
  dbms_output.put_line(v_msg);

  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  if v_payment_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;

    if v_reason is null then
    dbms_output.put_line('Причина не может быть пустой');
  end if;
end;
/

-- Отмена платежа с указанием причины
declare
  c_status_canceled constant payment.status%type := 3;
  v_payment_id payment.payment_id%type := 0;
  v_date date := sysdate;
  v_reason payment.status_change_reason%type := 'ошибка пользователя';
  v_msg varchar2(250 char) := 'Отмена платежа с указанием причины. Статус: ' || c_status_canceled || '. Причина: ' || v_reason;
begin
  dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.FMRM.yyyy'));
  dbms_output.put_line(v_msg);

  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  if v_payment_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;

    if v_reason is null then
    dbms_output.put_line('Причина не может быть пустой');
  end if;
end;
/

-- Успешное завершение платежа
declare
  c_status_finished constant payment.status%type := 1;
  v_payment_id payment.payment_id%type := 0;
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Успешное завершение платежа. Статус: ' || c_status_finished;
begin
  dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yy hh24:mi:ss'));
  dbms_output.put_line(v_msg);

  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  if v_payment_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;
end;
/

-- Данные платежа добавлены или обновлены
declare
  v_payment_id payment.payment_id%type := 0;
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Данные платежа добавлены или обновлены по списку id_поля/значение';
	v_payment_data t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE_2'),
																																  t_payment_detail(2, 'IP_2'),
																																  t_payment_detail(3, 'NOTE_2'),
																																  t_payment_detail(4, 'IS_CHECKED_FRAUD_2')
																																 );
begin
  dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'dd.mm.yyyy hh:mi AM'));
  dbms_output.put_line(v_msg);

  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  if v_payment_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;
  
  if v_payment_data is not empty then
    for i in v_payment_data.first..v_payment_data.last loop
    	if v_payment_data(i).field_type is null then
    	  dbms_output.put_line('ID поля не может быть пустым');
    	end if;
    	if v_payment_data(i).field_value is null then
    	  dbms_output.put_line('Значение в поле не может быть пустым');
    	end if;
  	  dbms_output.put_line('field_type = ' || v_payment_data(i).field_type || ', field_value = ' || v_payment_data(i).field_value );
    end loop;
  else
    dbms_output.put_line('Коллекция не содержит данных');
  end if;
end;
/

-- Детали платежа удалены
declare
  v_payment_id payment.payment_id%type := 0;
  v_date date := sysdate;
  v_msg varchar2(250 char) := 'Детали платежа удалены по списку id_полей';
	v_payment_delete_ids t_number_array := t_number_array(1, 2, 3);
begin
  dbms_output.put_line('Текущая дата: ' || to_char(v_date, 'DDD') || '''s day of year');
  dbms_output.put_line(v_msg);

  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  if v_payment_id is null then
    dbms_output.put_line('ID объекта не может быть пустым');
  end if;
  
  if v_payment_delete_ids is empty then
    dbms_output.put_line('Коллекция не содержит данных');
  end if;
  dbms_output.put_line('Количество полей для удаления = ' || v_payment_delete_ids.count());
end;
/
