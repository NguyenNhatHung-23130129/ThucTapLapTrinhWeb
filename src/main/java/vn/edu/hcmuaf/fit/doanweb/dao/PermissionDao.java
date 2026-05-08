package vn.edu.hcmuaf.fit.doanweb.dao;

import java.util.List;

public class PermissionDao extends BaseDao {


    private static PermissionDao instance;

    private PermissionDao() {
    }

    public static PermissionDao getInstance() {
        if (instance == null) {
            instance = new PermissionDao();
        }
        return instance;
    }

    public List<String> getUserPermissions(int userId) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT DISTINCT p.permission_key " +
                                        "FROM permissions p JOIN role_permissions rp ON p.id = rp.permission_id JOIN user_roles ur ON rp.role_id = ur.role_id " +
                                        "WHERE ur.user_id = :userId"
                        )
                        .bind("userId", userId)
                        .mapTo(String.class)
                        .list()
        );
    }

    public List<String> getUserRoles(int userId) {
        return get().withHandle(handle ->
                handle.createQuery(
                                "SELECT r.role_key " +
                                        "FROM role r JOIN user_roles ur ON r.id = ur.role_id " +
                                        "WHERE ur.user_id = :userId"
                        )
                        .bind("userId", userId)
                        .mapTo(String.class)
                        .list()
        );
    }

    public void logAudit(int actorId, String actionType, String metadata) {
        get().withHandle(handle ->
                handle.createUpdate("INSERT INTO access_audit (actor_id, action_type, metadata) VALUES (:actorId, :actionType, :metadata)")
                        .bind("actorId", actorId)
                        .bind("actionType", actionType)
                        .bind("metadata", metadata)
                        .execute()
        );
    }
}
