package vn.edu.hcmuaf.fit.doanweb.model;

import java.io.Serializable;
import java.util.List;

public class Permission implements Serializable {
    private int id;
    private List<Resource> resources;
    private int uId;
    private int per;//quyen 1-xem 2-sua 3-toan quyen

    public Permission() {
    }

    public Permission(List<Resource> resource, int id, int uId, int permissionType) {
        this.resources = resource;
        this.id = id;
        this.uId = uId;
        this.per = permissionType;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public List<Resource> getResource() {
        return resources;
    }

    public void setResource(List<Resource> resource) {
        this.resources = resource;
    }

    public int getuId() {
        return uId;
    }

    public void setuId(int uId) {
        this.uId = uId;
    }

    public int getPer() {
        return per;
    }

    public void setPer(int permissionType) {
        this.per = permissionType;
    }
   
}
