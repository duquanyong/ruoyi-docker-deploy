-- 数据统计菜单
SET @store_menu_id = (SELECT menu_id FROM sys_menu WHERE menu_name = '店掌柜' LIMIT 1);

-- 删除已存在的统计菜单
DELETE FROM sys_menu WHERE menu_name IN ('数据统计', '营业概况', '商品排行', '会员分析', '库存分析');

-- 数据统计子菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('数据统计', @store_menu_id, 5, 'statistics', NULL, 1, 0, 'M', '0', '0', NULL, 'chart', 'admin', NOW(), 'admin', NOW(), '数据统计');

SET @statistics_menu_id = LAST_INSERT_ID();

-- 营业概况
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('营业概况', @statistics_menu_id, 1, 'overview', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:overview', 'dashboard', 'admin', NOW(), 'admin', NOW(), '营业概况');
SET @overview_menu_id = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('概况查询', @overview_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:overview', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 商品排行
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品排行', @statistics_menu_id, 2, 'productRank', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:product', 'trend-charts', 'admin', NOW(), 'admin', NOW(), '商品排行');
SET @productRank_menu_id = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('排行查询', @productRank_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:product', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 会员分析
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员分析', @statistics_menu_id, 3, 'memberStats', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:member', 'peoples', 'admin', NOW(), 'admin', NOW(), '会员分析');
SET @memberStats_menu_id = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('分析查询', @memberStats_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:member', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 库存分析
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('库存分析', @statistics_menu_id, 4, 'stockStats', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:stock', 'inventory', 'admin', NOW(), 'admin', NOW(), '库存分析');
SET @stockStats_menu_id = LAST_INSERT_ID();
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('库存查询', @stockStats_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:stock', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 给管理员角色分配权限
INSERT IGNORE INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_name IN (
  '数据统计', '营业概况', '概况查询',
  '商品排行', '排行查询',
  '会员分析', '分析查询',
  '库存分析', '库存查询'
);
