create or replace package body common_pack is
 
  g_enable_manual_changes boolean := false;
 
  -- Включение-отключение возможности менять вручную данные объектов
  procedure enable_manual_changes 
  is
  begin
    g_enable_manual_changes := true;
  end enable_manual_changes;
  
  procedure disable_manual_changes 
  is
  begin
    g_enable_manual_changes := false;
  end disable_manual_changes;
  
  -- разрешены ли ручные изменения на глобальном уровне
  function is_manual_changes_allowed return boolean 
  is
  begin
    return g_enable_manual_changes;
  end;
  
end common_pack;
/
