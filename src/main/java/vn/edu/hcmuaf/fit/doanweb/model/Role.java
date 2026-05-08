package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;

public class Role  implements Serializable {
    private int id;
    private String name;
    private String roleKey;

    public Role() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getRoleKey() { return roleKey; }
    public void setRoleKey(String roleKey) { this.roleKey = roleKey; }
}