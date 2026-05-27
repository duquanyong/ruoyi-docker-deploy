-- ----------------------------
-- 店掌柜菜单初始化
-- ----------------------------

-- 先删除已存在的菜单（避免重复插入）
DELETE FROM sys_menu WHERE menu_name IN ('店掌柜', '商品管理', '商品分类', '商品列表');

-- 店掌柜主菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('店掌柜', 0, 5, 'store', NULL, 1, 0, 'M', '0', '0', NULL, 'shopping', 'admin', NOW(), 'admin', NOW(), '店掌柜模块');

-- 获取店掌柜菜单ID
SET @store_menu_id = LAST_INSERT_ID();

-- 商品管理子菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品管理', @store_menu_id, 1, 'product', NULL, 1, 0, 'M', '0', '0', NULL, 'goods', 'admin', NOW(), 'admin', NOW(), '商品管理');

SET @product_menu_id = LAST_INSERT_ID();

-- 商品分类菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品分类', @product_menu_id, 1, 'category', 'store/category/index', 1, 0, 'C', '0', '0', 'store:category:list', 'tree', 'admin', NOW(), 'admin', NOW(), '商品分类');

SET @category_menu_id = LAST_INSERT_ID();

-- 商品分类按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('分类查询', @category_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:query', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('分类新增', @category_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:add', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('分类修改', @category_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:edit', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('分类删除', @category_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:category:remove', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 商品列表菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品列表', @product_menu_id, 2, 'product', 'store/product/index', 1, 0, 'C', '0', '0', 'store:product:list', 'list', 'admin', NOW(), 'admin', NOW(), '商品列表');

SET @product_list_menu_id = LAST_INSERT_ID();

-- 商品按钮权限
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品查询', @product_list_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:query', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品新增', @product_list_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:add', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品修改', @product_list_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:edit', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品删除', @product_list_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:remove', '#', 'admin', NOW(), 'admin', NOW(), '');

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('商品导出', @product_list_menu_id, 5, '#', NULL, 1, 0, 'F', '0', '0', 'store:product:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 库存管理子菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('库存管理', @store_menu_id, 2, 'stock', NULL, 1, 0, 'M', '0', '0', NULL, 'inventory', 'admin', NOW(), 'admin', NOW(), '库存管理');

SET @stock_menu_id = LAST_INSERT_ID();

-- 供应商管理菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('供应商管理', @stock_menu_id, 1, 'supplier', 'store/supplier/index', 1, 0, 'C', '0', '0', 'store:supplier:list', 'user', 'admin', NOW(), 'admin', NOW(), '供应商管理');

SET @supplier_menu_id = LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('供应商查询', @supplier_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('供应商新增', @supplier_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('供应商修改', @supplier_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('供应商删除', @supplier_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('供应商导出', @supplier_menu_id, 5, '#', NULL, 1, 0, 'F', '0', '0', 'store:supplier:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 库存流水菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('库存流水', @stock_menu_id, 2, 'stockRecord', 'store/stockRecord/index', 1, 0, 'C', '0', '0', 'store:stockRecord:list', 'log', 'admin', NOW(), 'admin', NOW(), '库存流水');

SET @stockRecord_menu_id = LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('流水查询', @stockRecord_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('流水新增', @stockRecord_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('流水删除', @stockRecord_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('流水导出', @stockRecord_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:stockRecord:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 会员管理子菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员管理', @store_menu_id, 3, 'member', NULL, 1, 0, 'M', '0', '0', NULL, 'peoples', 'admin', NOW(), 'admin', NOW(), '会员管理');

SET @member_menu_id = LAST_INSERT_ID();

-- 会员列表菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员列表', @member_menu_id, 1, 'member', 'store/member/index', 1, 0, 'C', '0', '0', 'store:member:list', 'user', 'admin', NOW(), 'admin', NOW(), '会员列表');

SET @member_list_menu_id = LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员查询', @member_list_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员新增', @member_list_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员修改', @member_list_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员删除', @member_list_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员导出', @member_list_menu_id, 5, '#', NULL, 1, 0, 'F', '0', '0', 'store:member:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 会员等级菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('会员等级', @member_menu_id, 2, 'memberLevel', 'store/memberLevel/index', 1, 0, 'C', '0', '0', 'store:memberLevel:list', 'star', 'admin', NOW(), 'admin', NOW(), '会员等级');

SET @memberLevel_menu_id = LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('等级查询', @memberLevel_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('等级新增', @memberLevel_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('等级修改', @memberLevel_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:edit', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('等级删除', @memberLevel_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:memberLevel:remove', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 订单管理子菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单管理', @store_menu_id, 4, 'order', NULL, 1, 0, 'M', '0', '0', NULL, 'order', 'admin', NOW(), 'admin', NOW(), '订单管理');

SET @order_menu_id = LAST_INSERT_ID();

-- 销售订单菜单
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('销售订单', @order_menu_id, 1, 'order', 'store/order/index', 1, 0, 'C', '0', '0', 'store:order:list', 'list', 'admin', NOW(), 'admin', NOW(), '销售订单');

SET @order_list_menu_id = LAST_INSERT_ID();

INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单查询', @order_list_menu_id, 1, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:query', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单新增', @order_list_menu_id, 2, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:add', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单删除', @order_list_menu_id, 3, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:remove', '#', 'admin', NOW(), 'admin', NOW(), '');
INSERT INTO sys_menu (menu_name, parent_id, order_num, path, component, is_frame, is_cache, menu_type, visible, status, perms, icon, create_by, create_time, update_by, update_time, remark)
VALUES ('订单导出', @order_list_menu_id, 4, '#', NULL, 1, 0, 'F', '0', '0', 'store:order:export', '#', 'admin', NOW(), 'admin', NOW(), '');

-- 给管理员角色分配权限
INSERT INTO sys_role_menu (role_id, menu_id)
SELECT 1, menu_id FROM sys_menu WHERE menu_name IN (
  '店掌柜', '商品管理', '商品分类', '商品列表', '分类查询', '分类新增', '分类修改', '分类删除', '商品查询', '商品新增', '商品修改', '商品删除', '商品导出',
  '库存管理', '供应商管理', '供应商查询', '供应商新增', '供应商修改', '供应商删除', '供应商导出',
  '库存流水', '流水查询', '流水新增', '流水删除', '流水导出',
  '会员管理', '会员列表', '会员查询', '会员新增', '会员修改', '会员删除', '会员导出',
  '会员等级', '等级查询', '等级新增', '等级修改', '等级删除',
  '订单管理', '销售订单', '订单查询', '订单新增', '订单删除', '订单导出'
);
