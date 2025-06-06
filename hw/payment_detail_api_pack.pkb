create or replace package body payment_detail_api_pack
as
  g_is_api boolean := false;
  
  procedure allow_changes is
  begin
    g_is_api := true;
  end allow_changes;
  
  procedure disallow_changes is
  begin
    g_is_api := false;
  end disallow_changes;
  
  -- ƒанные платежа добавлены или обновлены
  procedure insert_or_update_payment_detail(p_payment_id   payment.payment_id%type,
                                            p_payment_data t_payment_detail_array)
  is
  begin
    allow_changes();
    
    if p_payment_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_object_id);
    end if;
    
    if p_payment_data is not empty then
      for i in p_payment_data.first..p_payment_data.last loop
        if p_payment_data(i).field_type is null then
          raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_field_id);
        end if;
        if p_payment_data(i).field_value is null then
          raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_field_value);
        end if;
      end loop;
    else
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_collection);
    end if;
    
    merge into payment_detail pd
      using (select * from table(p_payment_data)) v on (pd.payment_id = p_payment_id and pd.field_id = v.field_type)
      when matched then 
        update set pd.field_value = v.field_value
      when not matched then 
        insert (payment_id, field_id, field_value) values (p_payment_id, v.field_type, v.field_value);
       
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end insert_or_update_payment_detail;
  

  -- ƒетали платежа удалены
  procedure delete_payment_detail(p_payment_id         payment.payment_id%type,
                                  p_payment_delete_ids t_number_array)
  is
  begin
    allow_changes();
    
    if p_payment_id is null then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_field_id);
    end if;
    
    if p_payment_delete_ids is empty then
      raise_application_error(common_pack.c_error_code_invalid_input_parameter, common_pack.c_err_msg_empty_collection);
    end if;
    
    forall i in p_payment_delete_ids.first..p_payment_delete_ids.last
      delete from payment_detail 
        where payment_id = p_payment_id 
          and field_id = p_payment_delete_ids(i);
       
    disallow_changes();
  exception
    when others then
      disallow_changes();
      raise;
  end delete_payment_detail;
   
  -- проверка, провод¤тс¤ ли изменени¤ через API
  procedure is_changes_through_api is
  begin
    if not g_is_api and not common_pack.is_manual_changes_allowed then
      raise_application_error(common_pack.c_error_code_manual_changes, common_pack.c_err_msg_manual_changes);
    end if;
  end;
end payment_detail_api_pack;
/
