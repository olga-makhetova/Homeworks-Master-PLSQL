/*
  Автор: Махетова Ольга
  Описание пакета: API для сущностей “Платеж”
*/

create or replace package payment_api_pack
is
  -- статусы платежа
  c_status_created  constant payment.status%type := 0;
  c_status_finished constant payment.status%type := 1;
  c_status_error    constant payment.status%type := 2;
  c_status_canceled constant payment.status%type := 3;

  -- сообщения об ошибках
  c_err_msg_empty_collection  constant varchar2(250 char) := 'Коллекция не содержит данных'; 
  c_err_msg_empty_field_id    constant varchar2(250 char) := 'ID поля не может быть пустым'; 
  c_err_msg_empty_field_value constant varchar2(250 char) := 'Значение в поле не может быть пустым';  
  c_err_msg_empty_object_id   constant varchar2(250 char) := 'ID объекта не может быть пустым';  
  c_err_msg_empty_reason      constant varchar2(250 char) := 'Причина не может быть пустой';
  c_err_msg_delete_forbidden  constant varchar2(250 char) := 'Удаление объекта запрещено!';
  c_err_msg_manual_changes    constant varchar2(250 char) := 'Изменения должны выполняться только через API!';
 
  -- коды ошибок
  c_error_code_invalid_input_parameter constant number(10) := -20101;
  c_error_code_delete_forbidden        constant number(10) := -20102;
  c_error_code_manual_changes          constant number(10) := -20103;
  
  -- объекты исключений
  e_invalid_input_parameter exception;
--  pragma exception_init (e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  pragma exception_init (e_invalid_input_parameter, -20101);
  
  e_delete_forbidden exception;
--  pragma exception_init (e_delete_forbidden, c_error_code_delete_forbidden);
  pragma exception_init (e_delete_forbidden, -20102);
  
  e_manual_changes exception;
--  pragma exception_init (e_manual_changes, c_error_code_manual_changes);
  pragma exception_init (e_manual_changes, -20103);

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
  
  procedure is_changes_through_api;

end payment_api_pack;
/
