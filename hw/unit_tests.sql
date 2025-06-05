/*
  автор: Махетова Ольга
  описание скрипта: unit-тесты для API для сущностей "Платеж" и "Детали платежа"
*/

-- Создание платежа
declare
  v_payment_data t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE_1'),
                                                                  t_payment_detail(2, 'IP_1'),
                                                                  t_payment_detail(3, 'NOTE_1'),
                                                                  t_payment_detail(4, 'IS_CHECKED_FRAUD_1')
                                                                  );                                        
  v_summa          payment.summa%type := 1000;
  v_currency_id    payment.currency_id%type := 840;
  v_from_client_id payment.from_client_id%type := 1;
  v_to_client_id   payment.to_client_id%type := 2;
  v_payment_id     payment.payment_id%type;
  v_create_dtime_tech payment.create_dtime_tech %type;
  v_update_dtime_tech payment.update_dtime_tech%type;
begin
  v_payment_id := payment_api_pack.create_payment(v_payment_data, 
                                                  v_summa, 
                                                  v_currency_id,
                                                  v_from_client_id, 
                                                  v_to_client_id,
                                                  systimestamp
                                                  );
  dbms_output.put_line('v_payment_id = ' || v_payment_id);
  
  select create_dtime_tech, update_dtime_tech into v_create_dtime_tech, v_update_dtime_tech  
    from payment where payment_id = v_payment_id;
  
  if v_create_dtime_tech != v_update_dtime_tech then
    raise_application_error(-20000, 'Технические даты разные!!');
  end if;
end;
/

-- Сброс платежа в "ошибочный статус" с указанием причины
declare
  v_payment_id payment.payment_id%type := 42;
  v_reason payment.status_change_reason%type := 'недостаточно средств';
  v_create_dtime_tech payment.create_dtime_tech %type;
  v_update_dtime_tech payment.update_dtime_tech%type;
begin
  payment_api_pack.fail_payment(p_payment_id => v_payment_id,
                                p_reason     => v_reason
                                );
 
  select create_dtime_tech, update_dtime_tech into v_create_dtime_tech, v_update_dtime_tech  
    from payment where payment_id = v_payment_id;
  
  if v_create_dtime_tech = v_update_dtime_tech then
    raise_application_error(-20000, 'Технические даты одинаковые!!');
  end if; 
end;
/

-- Отмена платежа с указанием причины
declare
  v_payment_id payment.payment_id%type := 22;
  v_reason payment.status_change_reason%type := 'ошибка пользовател§';
begin
  payment_api_pack.cancel_payment(p_payment_id => v_payment_id,
                                  p_reason     => v_reason
                                  );
end;
/

-- Успешное завершение платежа
declare
  v_payment_id payment.payment_id%type := 23;
begin
  payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
end;
/

-- Данные платежа добавлены или обновлены
declare
  v_payment_id payment.payment_id%type := 21;
  v_payment_data t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE_2'),
                                                                  t_payment_detail(2, 'IP_2'),
                                                                  t_payment_detail(3, 'NOTE_2'),
                                                                  t_payment_detail(4, 'IS_CHECKED_FRAUD_2')
                                                                 );
begin
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id   => v_payment_id,
                                                          p_payment_data => v_payment_data
                                                          ); 
end;
/

-- Детали платежа удалены
declare
  v_payment_id payment.payment_id%type := 21;
  v_payment_delete_ids t_number_array := t_number_array(1, 2, 3);
begin
  payment_detail_api_pack.delete_payment_detail(p_payment_id         => v_payment_id,
                                                p_payment_delete_ids => v_payment_delete_ids
                                                );
end;
/


/*******************************************************************************
**          Проверка функционала по глобальному отключению проверок           **
*******************************************************************************/
-- удаление
declare 
  v_payment_id payment.payment_id%type := 21;
begin
  common_pack.enable_manual_changes;
  
  delete from payment where payment_id = v_payment_id;
  
  common_pack.disable_manual_changes;
exception
  when others then
    common_pack.disable_manual_changes;
end;
/

-- изменение платежа
declare 
  v_payment_id payment.payment_id%type := 22;
begin
  common_pack.enable_manual_changes;
  
  update payment set summa = summa + 100000 where payment_id = v_payment_id;
  
  common_pack.disable_manual_changes;
exception
  when others then
    common_pack.disable_manual_changes;
end;
/

-- изменение деталей платежа
declare 
  v_payment_id payment.payment_id%type := 22;
begin
  common_pack.enable_manual_changes;
  
  update payment_detail set field_value = '' where payment_id = v_payment_id and field_id = 1;
  
  common_pack.disable_manual_changes;
exception
  when others then
    common_pack.disable_manual_changes;
end;
/

/****************************************
**       Негативные unit-тесты         **
****************************************/
-- Создание платежа
declare
  v_payment_data t_payment_detail_array;                                        
  v_summa          payment.summa%type := 1000;
  v_currency_id    payment.currency_id%type := 840;
  v_from_client_id payment.from_client_id%type := 1;
  v_to_client_id   payment.to_client_id%type := 2;
  v_payment_id     payment.payment_id%type;
begin
  v_payment_id := payment_api_pack.create_payment(v_payment_data, 
                                                  v_summa, 
                                                  v_currency_id,
                                                  v_from_client_id, 
                                                  v_to_client_id,
                                                  systimestamp
                                                  );
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Создание платежа. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/


-- Сброс платежа в "ошибочный статус" с указанием причины
declare
  v_payment_id payment.payment_id%type;
  v_reason payment.status_change_reason%type := 'недостаточно средств';
begin
  payment_api_pack.fail_payment(p_payment_id => v_payment_id,
                                p_reason     => v_reason
                                );
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Сброс платежа в "ошибочный статус" с указанием причины. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- Отмена платежа с указанием причины
declare
  v_payment_id payment.payment_id%type := 22;
  v_reason payment.status_change_reason%type;
begin
  payment_api_pack.cancel_payment(p_payment_id => v_payment_id,
                                  p_reason     => v_reason
                                  );
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Отмена платежа с указанием причины. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- Успешное завершение платежа
declare
  v_payment_id payment.payment_id%type;
begin
  payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Успешное завершение платежа. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- Данные платежа добавлены или обновлены
declare
  v_payment_id payment.payment_id%type;
  v_payment_data t_payment_detail_array := t_payment_detail_array(t_payment_detail(1, 'CLIENT_SOFTWARE_2'),
                                                                  t_payment_detail(2, 'IP_2'),
                                                                  t_payment_detail(3, 'NOTE_2'),
                                                                  t_payment_detail(4, 'IS_CHECKED_FRAUD_2')
                                                                 );
begin
  payment_detail_api_pack.insert_or_update_payment_detail(p_payment_id   => v_payment_id,
                                                          p_payment_data => v_payment_data
                                                          ); 
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Данные платежа добавлены или обновлены. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- Детали платежа удалены
declare
  v_payment_id payment.payment_id%type := 21;
  v_payment_delete_ids t_number_array := t_number_array();
begin
  payment_detail_api_pack.delete_payment_detail(p_payment_id         => v_payment_id,
                                                p_payment_delete_ids => v_payment_delete_ids
                                                );
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_invalid_input_parameter then
    dbms_output.put_line('Создание платежа. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- удаление платежа
declare
  v_payment_id payment.payment_id%type := 21;
begin
  delete from payment where payment_id = v_payment_id;
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_delete_forbidden then
    dbms_output.put_line('удаление платежа. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- вставка платежа не через апи
declare
  v_payment_id payment.payment_id%type := 777;
begin
 insert into payment(payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id) 
   values(v_payment_id, systimestamp, 100, 840, 1, 2);
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_manual_changes then
    dbms_output.put_line('вставка платежа не через апи. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- изменение платежа не через апи
declare
  v_payment_id payment.payment_id%type := 777;
begin
  update payment
    set summa = 100000
    where payment_id = v_payment_id;
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_manual_changes then
    dbms_output.put_line('изменение платежа не через апи. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- удаление деталей платежа
declare
  v_payment_id payment_detail.payment_id%type := 21;
begin
  delete from payment_detail where payment_id = v_payment_id;
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_manual_changes then
    dbms_output.put_line('удаление деталей платежа. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- вставка деталей платежа не через апи
declare
  v_payment_id payment.payment_id%type := 777;
begin
 insert into payment_detail(payment_id, field_id, field_value) 
   values(v_payment_id, 1, 'xxx');
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_manual_changes then
    dbms_output.put_line('вставка деталей платежа не через апи. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/

-- изменение платежа не через апи
declare
  v_payment_id payment.payment_id%type := 21;
begin
  update payment_detail
    set field_value = '100000'
    where payment_id = v_payment_id
      and field_id = 1;
  raise_application_error(-20999, 'Unit-тесты или API выполнены неверно!');
exception
  when payment_api_pack.e_manual_changes then
    dbms_output.put_line('изменение деталей платежа не через апи. Исключение возбуждено успешно. Ошибка: ' || sqlerrm);
end;
/
