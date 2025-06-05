/*
  Автор: Махетова Ольга
  описание пакета: API для сущностей "платеж"
*/

create or replace package payment_api_pack
is
  -- Создание платежа
  function create_payment(p_payment_data   t_payment_detail_array,
                          p_summa          payment.summa%type,
                          p_currency_id    payment.currency_id%type,
                          p_from_client_id payment.from_client_id%type,
                          p_to_client_id   payment.to_client_id%type,
                          p_create_dtime   payment.create_dtime%type
                          ) return payment.payment_id%type;
  
  -- Сброс платежа в "ошибочный статус" с указанием причины
  procedure fail_payment(p_payment_id payment.payment_id%type,
                         p_reason     payment.status_change_reason%type
                         );
  
  -- Отмена платежа с указанием причины
  procedure cancel_payment(p_payment_id payment.payment_id%type,
                           p_reason     payment.status_change_reason%type
                           );
  
  -- Успешное завершение платежа
  procedure successful_finish_payment(p_payment_id payment.payment_id%type);      
  
  -- для триггеров
  procedure is_changes_through_api;
  
  procedure check_payment_delete_restriction;

end payment_api_pack;
/
