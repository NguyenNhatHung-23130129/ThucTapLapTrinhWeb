package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;

public class Permission implements Serializable {
    private int id;
    private String permissionKey;
    private String resource;
    private String action;

    public Permission() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getPermissionKey() { return permissionKey; }
    public void setPermissionKey(String permissionKey) { this.permissionKey = permissionKey; }
    public String getResource() { return resource; }
    public void setResource(String resource) { this.resource = resource; }
    public String getAction() { return action; }
    public void setAction(String action) { this.action = action; }
}