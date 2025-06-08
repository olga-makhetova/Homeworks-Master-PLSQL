create or replace package common_pack is

  -- Author  : MAHETOVAOY
  -- Created : 04.06.2025 23:23:13
  -- Purpose : Общий функционал для сущностей "Платеж" и "Детали платежа"
  -- статусы платежа
  c_status_created  constant payment.status%type := 0;
  c_status_finished constant payment.status%type := 1;
  c_status_error    constant payment.status%type := 2;
  c_status_canceled constant payment.status%type := 3;

  -- сообщения об ошибках
  c_err_msg_empty_collection       constant varchar2(250 char) := 'Коллекция не содержит данных'; 
  c_err_msg_empty_field_id         constant varchar2(250 char) := 'ID поля не может быть пустым'; 
  c_err_msg_empty_field_value      constant varchar2(250 char) := 'Значение в поле не может быть пустым';  
  c_err_msg_empty_object_id        constant varchar2(250 char) := 'ID объекта не может быть пустым';  
  c_err_msg_empty_reason           constant varchar2(250 char) := 'Причина не может быть пустой';
  c_err_msg_delete_forbidden       constant varchar2(250 char) := 'Удаление объекта запрещено!';
  c_err_msg_manual_changes         constant varchar2(250 char) := 'Изменения должны выполняться только через API!';
  c_err_msg_final_status           constant varchar2(250 char) := 'Объект в конечном статусе. Изменения невозможны';
  c_err_msg_object_notfound        constant varchar2(250 char) := 'Объект не найден';
  c_err_msg_object_already_locked  constant varchar2(250 char) := 'Объект уже заблокирован';
  
  -- коды ошибок
  c_error_code_invalid_input_parameter constant number(10) := -20101;
  c_error_code_delete_forbidden        constant number(10) := -20102;
  c_error_code_manual_changes          constant number(10) := -20103;
  c_error_code_final_status            constant number(10) := -20104;
  c_error_code_object_notfound         constant number(10) := -20105;
  c_error_code_object_already_locked   constant number(10) := -20106;
  
  -- объекты исключений
  e_invalid_input_parameter exception;
  pragma exception_init (e_invalid_input_parameter, c_error_code_invalid_input_parameter);
  
  e_delete_forbidden exception;
  pragma exception_init (e_delete_forbidden, c_error_code_delete_forbidden);
  
  e_manual_changes exception;
  pragma exception_init (e_manual_changes, c_error_code_manual_changes);
  
  e_final_status exception;
  pragma exception_init (e_final_status, c_error_code_final_status);
  
  e_object_notfound exception;
  pragma exception_init (e_object_notfound, c_error_code_object_notfound);
  
  e_row_locked exception;
  pragma exception_init (e_row_locked, -00054);
  
  
  -- Включение-отключение возможности менять вручную данные объектов
  procedure enable_manual_changes;
  procedure disable_manual_changes;

  -- разрешены ли ручные изменения на глобальном уровне
  function is_manual_changes_allowed return boolean;
  
end common_pack;
/
