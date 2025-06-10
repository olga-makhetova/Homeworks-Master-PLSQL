create or replace package body payment_api_pack
is
  g_is_api boolean := false;
  
  procedure allow_changes is
  begin
    g_is_api := true;
  end allow_changes;
  
  procedure disallow_changes is
  begin
    g_is_api := false;
  end disallow_changes;

  -- запрос на блокировку
  procedure try_lock_payment(p_payment_id payment.payment_id%type)
  is
    v_status payment.status%type;
  begin
    select status into v_status 
      from payment 
     where payment_id = p_payment_id 
       for update nowait;
       
     if v_status <> common_pack.c_status_created then
       raise_application_error(common_pack.c_error_code_final_status, common_pack.c_err_msg_final_status);
     end if;
     
  exception
    when no_data_found then
       raise_application_error(common_pack.c_error_code_object_notfound, common_pack.c_err_msg_object_notfound);
    when common_pack.e_row_locked then
       raise_application_error(common_pack.c_error_code_object_already_locked, common_pack.c_err_msg_object_already_locked);
  end try_lock_payment;

  -- Создание платежа
  function create_payment(p_payment_data   t_payment_detail_array,
                          p_summa          payment.summa%type,
                          p_currency_id    payment.currency_id%type,
                          p_from_client_id payment.from_client_id%type,
                          p_to_client_id   payment.to_client_id%type,
                          p_create_dtime   payment.create_dtime%type
                          ) return payment.payment_id%type 
  is
    v_payment_id payment.payment_id%type;
  begin
    allow_changes();
    
    -- добавление платежа
    insert into payment(payment_id, create_dtime, summa, currency_id, from_client_id, to_client_id)
      values(payment_seq.nextval, p_create_dtime, p_summa, p_currency_id, p_from_client_id, p_to_client_id)
      returning payment_id into v_payment_id;
    
    -- добавление деталей платежа
    payment_detail_api_pack.insert_or_update_payment_detail(v_payment_id, p_payment_data);
    
    disallow_changes();
    return v_payment_id;
  exception
    when others then
      disallow_changes();
      raise;
  end create_payment;

  -- Сброс платежа в "ошибочный статус" с указанием причины
  procedure fail_payment(p_payment_id payment.payment_id%type,
                         p_reason     payment.status_change_reason%type
                         )
  is
  begin
    try_lock_payment(p_payment_id);
    allow_changes();

    if p_payment_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_object_id);
    end if;

    if p_reason is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_reason);
    end if;
      
    update payment
       set status = common_pack.c_status_error,
           status_change_reason = p_reason
     where payment_id = p_payment_id 
       and status = common_pack.c_status_created; 
    
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end fail_payment;


  -- Отмена платежа с указанием причины
  procedure cancel_payment(p_payment_id payment.payment_id%type,
                           p_reason     payment.status_change_reason%type
                           )
  is
  begin
    try_lock_payment(p_payment_id);
    allow_changes();

    if p_payment_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_object_id);
    end if;

    if p_reason is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_reason);
    end if;
      
    update payment
       set status = common_pack.c_status_canceled,
           status_change_reason = p_reason
     where payment_id = p_payment_id 
       and status = common_pack.c_status_created; 
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end cancel_payment;

  -- Успешное завершение платежа
  procedure successful_finish_payment(p_payment_id payment.payment_id%type)
  is
  begin
    try_lock_payment(p_payment_id);
    allow_changes();

    if p_payment_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_object_id);
    end if;
      
    update payment
       set status = common_pack.c_status_finished,
            status_change_reason = ''
     where payment_id = p_payment_id 
       and status = common_pack.c_status_created; 
       
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end successful_finish_payment;
  
  -- проверка, проводятся ли изменения через API
  procedure is_changes_through_api is
  begin
    if not g_is_api and not common_pack.is_manual_changes_allowed then
      raise_application_error(common_pack.c_error_code_manual_changes, common_pack.c_err_msg_manual_changes);
    end if;
  end;
  
  -- возможность удаления данных
  procedure check_payment_delete_restriction
  is
  begin
    if not common_pack.is_manual_changes_allowed then
      raise_application_error(common_pack.c_error_code_delete_forbidden, common_pack.c_err_msg_delete_forbidden);
    end if;
    
  end check_payment_delete_restriction;
    
end payment_api_pack;
/
