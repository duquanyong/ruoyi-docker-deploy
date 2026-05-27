-- ========================================================
-- 店掌柜 - 完整初始化数据脚本
-- 包含：菜单权限、字典数据、业务数据、统计数据
-- 执行时机：在 02-store.sql（建表）之后执行
-- ========================================================

-- ----------------------------
-- 1. 字典数据（使用 INSERT IGNORE 避免重复）
-- ----------------------------
INSERT IGNORE INTO sys_dict_type (dict_name, dict_type, status, create_by, create_time, remark) VALUES
('库存操作类型', 'stock_operate_type', '0', 'admin', NOW(), '库存流水操作类型'),
('支付方式', 'pay_type', '0', 'admin', NOW(), '订单支付方式');

INSERT IGNORE INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) VALUES
(1, '采购入库', '1', 'stock_operate_type', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(2, '销售出库', '2', 'stock_operate_type', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '盘点盈亏', '3', 'stock_operate_type', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(4, '退货入库', '4', 'stock_operate_type', '', 'info', 'N', '0', 'admin', NOW(), ''),
(5, '其他', '5', 'stock_operate_type', '', '', 'N', '0', 'admin', NOW(), '');

INSERT IGNORE INTO sys_dict_data (dict_sort, dict_label, dict_value, dict_type, css_class, list_class, is_default, status, create_by, create_time, remark) VALUES
(1, '现金', '1', 'pay_type', '', 'primary', 'N', '0', 'admin', NOW(), ''),
(2, '微信', '2', 'pay_type', '', 'success', 'N', '0', 'admin', NOW(), ''),
(3, '支付宝', '3', 'pay_type', '', 'warning', 'N', '0', 'admin', NOW(), ''),
(4, '余额', '4', 'pay_type', '', 'danger', 'N', '0', 'admin', NOW(), ''),
(5, '刷卡', '5', 'pay_type', '', 'info', 'N', '0', 'admin', NOW(), '');

-- ----------------------------
-- 2. 菜单数据（完整菜单结构 + 按钮权限）
-- 注意：使用固定ID确保权限分配一致性
-- ----------------------------

-- 先清理已存在的店掌柜相关菜单
DELETE FROM sys_role_menu WHERE menu_id IN (SELECT menu_id FROM sys_menu WHERE perms LIKE 'store:%' OR menu_name IN ('店掌柜','商品管理','库存管理','会员管理','订单管理','数据统计'));
DELETE FROM sys_menu WHERE perms LIKE 'store:%' OR menu_name IN ('店掌柜','商品管理','库存管理','会员管理','订单管理','数据统计');

-- 店掌柜主菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2205, '店掌柜', 0, 1, 'store', NULL, 1, 0, 'M', '0', '0', NULL, 'shopping', 'admin', NOW(), 'admin', NOW(), '店掌柜主菜单');

-- 商品管理子菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2206, '商品管理', 2205, 1, 'product', NULL, 1, 0, 'M', '0', '0', NULL, 'goods', 'admin', NOW(), 'admin', NOW(), '商品管理');

-- 商品分类
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2207, '商品分类', 2206, 1, 'category', 'store/category/index', 1, 0, 'C', '0', '0', 'store:category:list', 'tree', 'admin', NOW(), 'admin', NOW(), '商品分类');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2208, '分类查询', 2207, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2209, '分类新增', 2207, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2210, '分类修改', 2207, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2211, '分类删除', 2207, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:remove', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 商品列表
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2212, '商品列表', 2206, 2, 'product', 'store/product/index', 1, 0, 'C', '0', '0', 'store:product:list', 'list', 'admin', NOW(), 'admin', NOW(), '商品列表');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2213, '商品查询', 2212, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2214, '商品新增', 2212, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2215, '商品修改', 2212, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2216, '商品删除', 2212, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2217, '商品导出', 2212, 5, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 库存管理子菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2218, '库存管理', 2205, 2, 'stock', NULL, 1, 0, 'M', '0', '0', NULL, 'inventory', 'admin', NOW(), 'admin', NOW(), '库存管理');

-- 供应商管理
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2219, '供应商管理', 2218, 1, 'supplier', 'store/supplier/index', 1, 0, 'C', '0', '0', 'store:supplier:list', 'user', 'admin', NOW(), 'admin', NOW(), '供应商管理');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2220, '供应商查询', 2219, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2221, '供应商新增', 2219, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2222, '供应商修改', 2219, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2223, '供应商删除', 2219, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2224, '供应商导出', 2219, 5, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 库存流水
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2225, '库存流水', 2218, 2, 'stockRecord', 'store/stockRecord/index', 1, 0, 'C', '0', '0', 'store:stockRecord:list', 'log', 'admin', NOW(), 'admin', NOW(), '库存流水');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2226, '流水查询', 2225, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2227, '流水新增', 2225, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2228, '流水删除', 2225, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2229, '流水导出', 2225, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 会员管理子菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2230, '会员管理', 2205, 3, 'member', NULL, 1, 0, 'M', '0', '0', NULL, 'peoples', 'admin', NOW(), 'admin', NOW(), '会员管理');

-- 会员列表
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2231, '会员列表', 2230, 1, 'member', 'store/member/index', 1, 0, 'C', '0', '0', 'store:member:list', 'user', 'admin', NOW(), 'admin', NOW(), '会员列表');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2232, '会员查询', 2231, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2233, '会员新增', 2231, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2234, '会员修改', 2231, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2235, '会员删除', 2231, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2236, '会员导出', 2231, 5, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 会员等级
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2237, '会员等级', 2230, 2, 'memberLevel', 'store/memberLevel/index', 1, 0, 'C', '0', '0', 'store:memberLevel:list', 'star', 'admin', NOW(), 'admin', NOW(), '会员等级');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2238, '等级查询', 2237, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2239, '等级新增', 2237, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2240, '等级修改', 2237, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2241, '等级删除', 2237, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:remove', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 订单管理子菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2242, '订单管理', 2205, 4, 'order', NULL, 1, 0, 'M', '0', '0', NULL, 'order', 'admin', NOW(), 'admin', NOW(), '订单管理');

-- 销售订单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2243, '销售订单', 2242, 1, 'order', 'store/order/index', 1, 0, 'C', '0', '0', 'store:order:list', 'list', 'admin', NOW(), 'admin', NOW(), '销售订单');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2244, '订单查询', 2243, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2245, '订单新增', 2243, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2246, '订单删除', 2243, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2247, '订单导出', 2243, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 数据统计子菜单
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2248, '数据统计', 2205, 5, 'statistics', NULL, 1, 0, 'M', '0', '0', NULL, 'chart', 'admin', NOW(), 'admin', NOW(), '数据统计');

-- 营业概况
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2249, '营业概况', 2248, 1, 'overview', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:overview', 'dashboard', 'admin', NOW(), 'admin', NOW(), '营业概况');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2250, '概况查询', 2249, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:overview', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 商品排行
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2251, '商品排行', 2248, 2, 'productRank', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:product', 'trend-charts', 'admin', NOW(), 'admin', NOW(), '商品排行');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2252, '排行查询', 2251, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:product', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 会员分析
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2253, '会员分析', 2248, 3, 'memberStats', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:member', 'peoples', 'admin', NOW(), 'admin', NOW(), '会员分析');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2254, '分析查询', 2253, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:member', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 库存分析
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2255, '库存分析', 2248, 4, 'stockStats', 'store/statistics/index', 1, 0, 'C', '0', '0', 'store:statistics:stock', 'inventory', 'admin', NOW(), 'admin', NOW(), '库存分析');
INSERT INTO sys_menu (menu_id, menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark) VALUES
(2256, '库存查询', 2255, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:statistics:stock', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 给管理员角色分配所有店掌柜权限
INSERT IGNORE INTO sys_role_menu (role_id, menu_id) VALUES
(1, 2205), (1, 2206), (1, 2207), (1, 2208), (1, 2209), (1, 2210), (1, 2211),
(1, 2212), (1, 2213), (1, 2214), (1, 2215), (1, 2216), (1, 2217),
(1, 2218), (1, 2219), (1, 2220), (1, 2221), (1, 2222), (1, 2223), (1, 2224),
(1, 2225), (1, 2226), (1, 2227), (1, 2228), (1, 2229),
(1, 2230), (1, 2231), (1, 2232), (1, 2233), (1, 2234), (1, 2235), (1, 2236),
(1, 2237), (1, 2238), (1, 2239), (1, 2240), (1, 2241),
(1, 2242), (1, 2243), (1, 2244), (1, 2245), (1, 2246), (1, 2247),
(1, 2248), (1, 2249), (1, 2250), (1, 2251), (1, 2252), (1, 2253), (1, 2254), (1, 2255), (1, 2256);

-- ----------------------------
-- 3. 业务数据 - 商品分类
-- ----------------------------
INSERT IGNORE INTO store_category (category_id, parent_id, category_name, order_num, status, create_by, create_time, remark) VALUES
(1, 0, '饮料', 1, '0', 'admin', NOW(), '各类饮品'),
(2, 0, '零食', 2, '0', 'admin', NOW(), '休闲零食'),
(3, 0, '日用品', 3, '0', 'admin', NOW(), '生活日用品'),
(4, 0, '粮油', 4, '0', 'admin', NOW(), '米面粮油'),
(5, 0, '生鲜', 5, '0', 'admin', NOW(), '新鲜蔬果'),
(6, 1, '碳酸饮料', 1, '0', 'admin', NOW(), '可乐雪碧等'),
(7, 1, '果汁', 2, '0', 'admin', NOW(), '鲜榨果汁'),
(8, 2, '膨化食品', 1, '0', 'admin', NOW(), '薯片虾条'),
(9, 2, '糖果', 2, '0', 'admin', NOW(), '巧克力糖果'),
(10, 5, '水果', 1, '0', 'admin', NOW(), '时令水果');

-- ----------------------------
-- 4. 业务数据 - 商品档案
-- ----------------------------
INSERT IGNORE INTO store_product (product_id, product_code, product_name, category_id, specification, unit, cost_price, sale_price, stock_quantity, safety_stock, barcode, status, del_flag, create_by, create_time, remark) VALUES
(1, 'SP001', '可口可乐330ml', 6, '330ml/罐', '罐', 2.50, 3.50, 200, 50, '6901234567890', '0', '0', 'admin', NOW(), '经典口味'),
(2, 'SP002', '雪碧330ml', 6, '330ml/罐', '罐', 2.50, 3.50, 180, 50, '6901234567891', '0', '0', 'admin', NOW(), '清爽柠檬'),
(3, 'SP003', '橙汁1L', 7, '1L/瓶', '瓶', 8.00, 12.00, 80, 20, '6901234567892', '0', '0', 'admin', NOW(), '100%纯果汁'),
(4, 'SP004', '乐事薯片原味', 8, '75g/袋', '袋', 4.50, 6.50, 150, 40, '6901234567893', '0', '0', 'admin', NOW(), '经典原味'),
(5, 'SP005', '德芙巧克力', 9, '43g/条', '条', 5.00, 8.00, 120, 30, '6901234567894', '0', '0', 'admin', NOW(), '丝滑牛奶'),
(6, 'SP006', '康师傅红烧牛肉面', 4, '5连包', '袋', 8.00, 12.50, 100, 25, '6901234567895', '0', '0', 'admin', NOW(), '经典口味'),
(7, 'SP007', '金龙鱼大米5kg', 4, '5kg/袋', '袋', 28.00, 39.90, 60, 15, '6901234567896', '0', '0', 'admin', NOW(), '东北大米'),
(8, 'SP008', '苹果', 10, '500g', '斤', 3.50, 5.99, 50, 10, '6901234567897', '0', '0', 'admin', NOW(), '红富士'),
(9, 'SP009', '香蕉', 10, '500g', '斤', 2.80, 4.50, 40, 10, '6901234567898', '0', '0', 'admin', NOW(), '进口香蕉'),
(10, 'SP010', '抽纸', 3, '3层120抽', '包', 1.50, 2.50, 300, 80, '6901234567899', '0', '0', 'admin', NOW(), '柔软亲肤');

-- ----------------------------
-- 5. 业务数据 - 供应商
-- ----------------------------
INSERT IGNORE INTO store_supplier (supplier_id, supplier_name, contact_person, contact_phone, address, status, del_flag, create_by, create_time, remark) VALUES
(1, '可口可乐公司', '张经理', '13800138001', '上海市浦东新区', '0', '0', 'admin', NOW(), '饮料供应商'),
(2, '百事食品', '李经理', '13800138002', '北京市朝阳区', '0', '0', 'admin', NOW(), '零食供应商'),
(3, '金龙鱼粮油', '王经理', '13800138003', '广州市天河区', '0', '0', 'admin', NOW(), '粮油供应商'),
(4, '本地果蔬批发', '赵经理', '13800138004', '深圳市福田区', '0', '0', 'admin', NOW(), '生鲜供应商'),
(5, '维达纸业', '陈经理', '13800138005', '杭州市西湖区', '0', '0', 'admin', NOW(), '日用品供应商');

-- ----------------------------
-- 6. 业务数据 - 库存流水（模拟近7天数据）
-- ----------------------------
INSERT IGNORE INTO store_stock_record (record_id, product_id, record_type, quantity, before_stock, after_stock, supplier_id, record_no, operate_type, create_by, create_time, remark) VALUES
(1, 1, '1', 100, 100, 200, 1, 'RK20260520001', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 6 DAY), '采购入库'),
(2, 2, '1', 80, 100, 180, 1, 'RK20260520002', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 6 DAY), '采购入库'),
(3, 4, '1', 50, 100, 150, 2, 'RK20260521001', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '采购入库'),
(4, 6, '1', 30, 70, 100, 3, 'RK20260521002', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '采购入库'),
(5, 1, '2', 20, 200, 180, NULL, 'CK20260522001', '2', 'admin', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '销售出库'),
(6, 4, '2', 15, 150, 135, NULL, 'CK20260522002', '2', 'admin', DATE_SUB(CURDATE(), INTERVAL 4 DAY), '销售出库'),
(7, 7, '1', 20, 40, 60, 3, 'RK20260523001', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '采购入库'),
(8, 8, '1', 30, 20, 50, 4, 'RK20260523002', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '采购入库'),
(9, 2, '2', 25, 180, 155, NULL, 'CK20260524001', '2', 'admin', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '销售出库'),
(10, 5, '2', 10, 120, 110, NULL, 'CK20260524002', '2', 'admin', DATE_SUB(CURDATE(), INTERVAL 2 DAY), '销售出库'),
(11, 3, '1', 40, 40, 80, 1, 'RK20260525001', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '采购入库'),
(12, 10, '1', 100, 200, 300, 5, 'RK20260525002', '1', 'admin', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '采购入库'),
(13, 1, '2', 30, 180, 150, NULL, 'CK20260526001', '2', 'admin', CURDATE(), '销售出库'),
(14, 6, '2', 20, 100, 80, NULL, 'CK20260526002', '2', 'admin', CURDATE(), '销售出库'),
(15, 8, '2', 15, 50, 35, NULL, 'CK20260526003', '2', 'admin', CURDATE(), '销售出库');

-- ----------------------------
-- 7. 业务数据 - 会员
-- ----------------------------
INSERT IGNORE INTO store_member (member_id, member_name, phone, gender, birthday, level_id, balance, points, total_amount, total_orders, last_time, status, create_by, create_time, remark) VALUES
(1, '张三', '13800138001', '0', '1990-05-15', 4, 500.00, 8000, 15000.00, 45, DATE_SUB(CURDATE(), INTERVAL 1 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 30 DAY), '钻石会员'),
(2, '李四', '13800138002', '0', '1988-08-20', 3, 300.00, 3500, 8000.00, 28, DATE_SUB(CURDATE(), INTERVAL 2 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 25 DAY), '金卡会员'),
(3, '王五', '13800138003', '1', '1995-03-10', 3, 200.00, 2800, 6500.00, 22, DATE_SUB(CURDATE(), INTERVAL 3 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 20 DAY), '金卡会员'),
(4, '赵六', '13800138004', '0', '1992-11-25', 2, 100.00, 800, 2500.00, 12, DATE_SUB(CURDATE(), INTERVAL 5 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 15 DAY), '银卡会员'),
(5, '钱七', '13800138005', '1', '1998-07-08', 2, 50.00, 600, 1800.00, 8, DATE_SUB(CURDATE(), INTERVAL 7 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 10 DAY), '银卡会员'),
(6, '孙八', '13800138006', '0', '2000-01-01', 1, 0.00, 100, 500.00, 3, DATE_SUB(CURDATE(), INTERVAL 10 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 5 DAY), '普通会员'),
(7, '周九', '13800138007', '1', '1993-09-18', 1, 0.00, 50, 300.00, 2, DATE_SUB(CURDATE(), INTERVAL 12 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 3 DAY), '普通会员'),
(8, '吴十', '13800138008', '0', '1996-04-22', 1, 0.00, 20, 150.00, 1, DATE_SUB(CURDATE(), INTERVAL 14 DAY), '0', 'admin', DATE_SUB(CURDATE(), INTERVAL 1 DAY), '普通会员');

-- ----------------------------
-- 8. 业务数据 - 会员等级
-- ----------------------------
INSERT IGNORE INTO store_member_level (level_id, level_name, min_points, discount, status, create_by, create_time, remark) VALUES
(1, '普通会员', 0, 1.00, '0', 'admin', NOW(), '默认等级'),
(2, '银卡会员', 500, 0.95, '0', 'admin', NOW(), '消费满500积分'),
(3, '金卡会员', 2000, 0.90, '0', 'admin', NOW(), '消费满2000积分'),
(4, '钻石会员', 5000, 0.85, '0', 'admin', NOW(), '消费满5000积分');

-- ----------------------------
-- 9. 业务数据 - 订单（模拟近7天数据）
-- ----------------------------
INSERT IGNORE INTO store_order (order_id, order_no, member_id, order_type, order_status, pay_type, total_amount, discount_amount, pay_amount, points_used, remark, create_by, create_time) VALUES
(1, 'DD20260520001', 1, '1', '1', '2', 156.50, 10.00, 146.50, 0, '微信支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(2, 'DD20260520002', 2, '1', '1', '1', 89.00, 5.00, 84.00, 0, '现金支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(3, 'DD20260521001', 3, '1', '1', '3', 245.00, 20.00, 225.00, 100, '支付宝支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(4, 'DD20260521002', NULL, '1', '1', '1', 35.50, 0.00, 35.50, 0, '散客现金', 'admin', DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(5, 'DD20260522001', 1, '1', '1', '4', 520.00, 50.00, 470.00, 200, '余额支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(6, 'DD20260522002', 4, '1', '1', '2', 78.00, 0.00, 78.00, 0, '微信支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(7, 'DD20260523001', 5, '1', '1', '1', 45.00, 0.00, 45.00, 0, '现金支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(8, 'DD20260523002', 2, '1', '1', '3', 198.00, 15.00, 183.00, 50, '支付宝支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(9, 'DD20260524001', 1, '1', '1', '2', 320.00, 30.00, 290.00, 0, '微信支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(10, 'DD20260524002', 3, '1', '1', '4', 150.00, 10.00, 140.00, 50, '余额支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(11, 'DD20260525001', 6, '1', '1', '1', 28.00, 0.00, 28.00, 0, '现金支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(12, 'DD20260525002', 1, '1', '1', '2', 450.00, 40.00, 410.00, 100, '微信支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(13, 'DD20260525003', 4, '1', '1', '3', 120.00, 10.00, 110.00, 0, '支付宝支付', 'admin', DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(14, 'DD20260526001', 2, '1', '1', '2', 256.00, 20.00, 236.00, 0, '微信支付', 'admin', CURDATE()),
(15, 'DD20260526002', 1, '1', '1', '4', 680.00, 60.00, 620.00, 300, '余额支付', 'admin', CURDATE()),
(16, 'DD20260526003', 7, '1', '1', '1', 56.00, 0.00, 56.00, 0, '现金支付', 'admin', CURDATE()),
(17, 'DD20260526004', 3, '1', '1', '2', 189.00, 15.00, 174.00, 0, '微信支付', 'admin', CURDATE()),
(18, 'DD20260526005', 5, '1', '1', '3', 98.00, 5.00, 93.00, 0, '支付宝支付', 'admin', CURDATE()),
(19, 'DD20260526006', NULL, '1', '1', '1', 42.00, 0.00, 42.00, 0, '散客现金', 'admin', CURDATE()),
(20, 'DD20260526007', 1, '1', '1', '2', 128.00, 10.00, 118.00, 0, '微信支付', 'admin', CURDATE());

-- ----------------------------
-- 10. 业务数据 - 订单明细
-- ----------------------------
INSERT IGNORE INTO store_order_item (item_id, order_id, product_id, product_name, specification, unit, sale_price, quantity, subtotal, create_time) VALUES
(1, 1, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 10, 35.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(2, 1, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 5, 32.50, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(3, 1, 5, '德芙巧克力', '43g/条', '条', 8.00, 8, 64.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(4, 1, 3, '橙汁1L', '1L/瓶', '瓶', 12.00, 2, 24.00, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(5, 2, 6, '康师傅红烧牛肉面', '5连包', '袋', 12.50, 3, 37.50, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(6, 2, 7, '金龙鱼大米5kg', '5kg/袋', '袋', 39.90, 1, 39.90, DATE_SUB(CURDATE(), INTERVAL 6 DAY)),
(7, 3, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 20, 70.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(8, 3, 2, '雪碧330ml', '330ml/罐', '罐', 3.50, 15, 52.50, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(9, 3, 5, '德芙巧克力', '43g/条', '条', 8.00, 10, 80.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(10, 3, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 6, 39.00, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(11, 4, 8, '苹果', '500g', '斤', 5.99, 3, 17.97, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(12, 4, 10, '抽纸', '3层120抽', '包', 2.50, 7, 17.50, DATE_SUB(CURDATE(), INTERVAL 5 DAY)),
(13, 5, 7, '金龙鱼大米5kg', '5kg/袋', '袋', 39.90, 5, 199.50, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(14, 5, 6, '康师傅红烧牛肉面', '5连包', '袋', 12.50, 10, 125.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(15, 5, 3, '橙汁1L', '1L/瓶', '瓶', 12.00, 8, 96.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(16, 5, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 12, 78.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(17, 6, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 8, 28.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(18, 6, 5, '德芙巧克力', '43g/条', '条', 8.00, 5, 40.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(19, 6, 10, '抽纸', '3层120抽', '包', 2.50, 4, 10.00, DATE_SUB(CURDATE(), INTERVAL 4 DAY)),
(20, 7, 8, '苹果', '500g', '斤', 5.99, 5, 29.95, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(21, 7, 9, '香蕉', '500g', '斤', 4.50, 3, 13.50, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(22, 8, 2, '雪碧330ml', '330ml/罐', '罐', 3.50, 18, 63.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(23, 8, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 8, 52.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(24, 8, 5, '德芙巧克力', '43g/条', '条', 8.00, 8, 64.00, DATE_SUB(CURDATE(), INTERVAL 3 DAY)),
(25, 9, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 30, 105.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(26, 9, 7, '金龙鱼大米5kg', '5kg/袋', '袋', 39.90, 3, 119.70, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(27, 9, 6, '康师傅红烧牛肉面', '5连包', '袋', 12.50, 5, 62.50, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(28, 9, 3, '橙汁1L', '1L/瓶', '瓶', 12.00, 3, 36.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(29, 10, 5, '德芙巧克力', '43g/条', '条', 8.00, 12, 96.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(30, 10, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 6, 39.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(31, 10, 10, '抽纸', '3层120抽', '包', 2.50, 6, 15.00, DATE_SUB(CURDATE(), INTERVAL 2 DAY)),
(32, 11, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 4, 14.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(33, 11, 8, '苹果', '500g', '斤', 5.99, 2, 11.98, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(34, 12, 7, '金龙鱼大米5kg', '5kg/袋', '袋', 39.90, 4, 159.60, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(35, 12, 6, '康师傅红烧牛肉面', '5连包', '袋', 12.50, 8, 100.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(36, 12, 3, '橙汁1L', '1L/瓶', '瓶', 12.00, 6, 72.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(37, 12, 5, '德芙巧克力', '43g/条', '条', 8.00, 10, 80.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(38, 13, 2, '雪碧330ml', '330ml/罐', '罐', 3.50, 10, 35.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(39, 13, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 8, 52.00, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(40, 13, 10, '抽纸', '3层120抽', '包', 2.50, 13, 32.50, DATE_SUB(CURDATE(), INTERVAL 1 DAY)),
(41, 14, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 15, 52.50, CURDATE()),
(42, 14, 5, '德芙巧克力', '43g/条', '条', 8.00, 10, 80.00, CURDATE()),
(43, 14, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 8, 52.00, CURDATE()),
(44, 14, 3, '橙汁1L', '1L/瓶', '瓶', 12.00, 6, 72.00, CURDATE()),
(45, 15, 7, '金龙鱼大米5kg', '5kg/袋', '袋', 39.90, 6, 239.40, CURDATE()),
(46, 15, 6, '康师傅红烧牛肉面', '5连包', '袋', 12.50, 15, 187.50, CURDATE()),
(47, 15, 3, '橙汁1L', '1L/瓶', '瓶', 12.00, 10, 120.00, CURDATE()),
(48, 15, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 10, 35.00, CURDATE()),
(49, 16, 8, '苹果', '500g', '斤', 5.99, 5, 29.95, CURDATE()),
(50, 16, 9, '香蕉', '500g', '斤', 4.50, 5, 22.50, CURDATE()),
(51, 16, 10, '抽纸', '3层120抽', '包', 2.50, 2, 5.00, CURDATE()),
(52, 17, 2, '雪碧330ml', '330ml/罐', '罐', 3.50, 20, 70.00, CURDATE()),
(53, 17, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 10, 65.00, CURDATE()),
(54, 17, 5, '德芙巧克力', '43g/条', '条', 8.00, 6, 48.00, CURDATE()),
(55, 18, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 8, 28.00, CURDATE()),
(56, 18, 6, '康师傅红烧牛肉面', '5连包', '袋', 12.50, 4, 50.00, CURDATE()),
(57, 18, 10, '抽纸', '3层120抽', '包', 2.50, 8, 20.00, CURDATE()),
(58, 19, 8, '苹果', '500g', '斤', 5.99, 3, 17.97, CURDATE()),
(59, 19, 9, '香蕉', '500g', '斤', 4.50, 4, 18.00, CURDATE()),
(60, 19, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 1, 6.50, CURDATE()),
(61, 20, 1, '可口可乐330ml', '330ml/罐', '罐', 3.50, 12, 42.00, CURDATE()),
(62, 20, 5, '德芙巧克力', '43g/条', '条', 8.00, 5, 40.00, CURDATE()),
(63, 20, 4, '乐事薯片原味', '75g/袋', '袋', 6.50, 4, 26.00, CURDATE()),
(64, 20, 10, '抽纸', '3层120抽', '包', 2.50, 8, 20.00, CURDATE());
