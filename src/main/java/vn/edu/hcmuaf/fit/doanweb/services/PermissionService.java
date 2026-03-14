package vn.edu.hcmuaf.fit.doanweb.services;

import vn.edu.hcmuaf.fit.doanweb.dao.BaseDao;
import vn.edu.hcmuaf.fit.doanweb.model.Permission;

import java.util.List;
import java.util.stream.Collectors;

public class PermissionService extends BaseDao {
    private static PermissionService instance;

    public PermissionService() {
    }

    public static PermissionService getInstance() {
        if (instance == null) {
            instance = new PermissionService();
        }
        return instance;
    }

    public int checkAccess(String rsName, int uId) {
        List<Permission> list = get().withHandle(handle -> {
            return handle.createQuery("SELECT permissions.id, permissions.u_id, permissions.per " +
                            "FROM permissions JOIN resources ON permissions.rs_id = resources.id " +
                            "WHERE permissions.u_id = :uid " +
                            "AND resources.`name` = :rsName " +
                            "AND resources.`status` = 1")
                    .bind("uid", uId)
                    .bind("rsName", rsName)
                    .mapToBean(Permission.class)
                    .stream().collect(Collectors.toList());
        });
        if (list == null) return 0;

        int max = 0;

        for (Permission p : list) {
            if (p.getPer() > max) max = p.getPer();
        }
        return max;

    }

    public static void main(String[] args) {
        int max = getInstance().checkAccess("product", 1);
        System.out.println(max);

    }
}
