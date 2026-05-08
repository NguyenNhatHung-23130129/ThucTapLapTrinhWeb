package vn.edu.hcmuaf.fit.doanweb.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.hcmuaf.fit.doanweb.model.Permission;
import vn.edu.hcmuaf.fit.doanweb.model.Role;

import java.util.List;

public class RolePermissionDao extends BaseDao {

    public List<Role> getAllRoles() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM role ORDER BY id ASC")
                .mapToBean(Role.class)
                .list());
    }

    public List<Permission> getAllPermissions() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM permissions ORDER BY resource ASC, id ASC")
                .mapToBean(Permission.class)
                .list());
    }

    public List<Integer> getPermissionIdsByRole(int roleId) {
        return get().withHandle(handle -> handle.createQuery("SELECT permission_id FROM role_permissions WHERE role_id = :roleId")
                .bind("roleId", roleId)
                .mapTo(Integer.class)
                .list());
    }

    public void updateRolePermissions(int roleId, List<Integer> permissionIds) {
        get().useTransaction(handle -> {
            handle.createUpdate("DELETE FROM role_permissions WHERE role_id = :roleId")
                    .bind("roleId", roleId)
                    .execute();

            if (permissionIds != null && !permissionIds.isEmpty()) {
                PreparedBatch batch = handle.prepareBatch("INSERT INTO role_permissions (role_id, permission_id) VALUES (:roleId, :permId)");
                for (Integer permId : permissionIds) {
                    batch.bind("roleId", roleId)
                            .bind("permId", permId)
                            .add();
                }
                batch.execute();
            }
        });
    }
}