/*
  автор: Махетова Ольга
  описание скрипта: unit-тесты для API для сущностей "Платеж" и "Детали платежа"
*/

select * from payment;

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
begin
  v_payment_id := payment_api_pack.create_payment(v_payment_data, 
                                                  v_summa, 
                                                  v_currency_id,
                                                  v_from_client_id, 
                                                  v_to_client_id,
                                                  systimestamp
                                                  );
  commit;
end;
/

select * from payment;
select * from payment_detail;

-- Сброс платежа в "ошибочный статус" с указанием причины
declare
  v_payment_id payment.payment_id%type := 21;
  v_reason payment.status_change_reason%type := 'недостаточно средств';
begin
  payment_api_pack.fail_payment(p_payment_id => v_payment_id,
                                p_reason     => v_reason
                                );
  commit;
end;
/

select * from payment;

-- Отмена платежа с указанием причины
declare
  v_payment_id payment.payment_id%type := 22;
  v_reason payment.status_change_reason%type := 'ошибка пользовател¤';
begin
  payment_api_pack.cancel_payment(p_payment_id => v_payment_id,
                                  p_reason     => v_reason
                                  );
  commit;
end;
/

select * from payment;

-- Успешное завершение платежа
declare
  v_payment_id payment.payment_id%type := 23;
begin
  payment_api_pack.successful_finish_payment(p_payment_id => v_payment_id);
  commit;
end;
/

select * from payment;
select * from payment_detail;

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
  commit;
end;
/

select * from payment_detail;

-- Детали платежа удалены
declare
  v_payment_id payment.payment_id%type := 21;
  v_payment_delete_ids t_number_array := t_number_array(1, 2, 3);
begin
  payment_detail_api_pack.delete_payment_detail(p_payment_id         => v_payment_id,
                                                p_payment_delete_ids => v_payment_delete_ids
                                                );
  commit;
end;
/
select * from payment_detail;
