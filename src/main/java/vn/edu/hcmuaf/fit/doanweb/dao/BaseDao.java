package vn.edu.hcmuaf.fit.doanweb.dao;

import com.mysql.cj.jdbc.MysqlDataSource;
import org.jdbi.v3.core.Jdbi;
import vn.edu.hcmuaf.fit.doanweb.model.Category;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.Properties;

public abstract class BaseDao {
    private Jdbi jdbi;

    public Jdbi get() {
        if (jdbi == null) makeConnect();
        return jdbi;
    }

    private void makeConnect() {
        MysqlDataSource dataSource = new MysqlDataSource();
        dataSource.setURL("jdbc:mysql://" + DBProperties.getDBHost() + ":" + DBProperties.getDBPort() + "/" + DBProperties.getDBName());
        dataSource.setUser(DBProperties.getUsername());
        dataSource.setPassword(DBProperties.getPassword());
        try {
            dataSource.setUseCompression(true);
            dataSource.setAutoReconnect(true);
        } catch (SQLException throwables) {
            System.out.println("LỖI KẾT NỐI: " + throwables.getMessage());
            throwables.printStackTrace();
            throw new RuntimeException("Lỗi kết nối cơ sở dữ liệu");
        }
        jdbi = Jdbi.create(dataSource);
    }

//    public static void main(String[] args) {
//        BaseDao baseDao = new BaseDao();
//        Jdbi jdbi = baseDao.get();
//        List<Category> categoryList = jdbi.withHandle(handle -> {
//            return handle.createQuery("select * from categories").mapToBean(Category.class).list();
//        });
//        System.out.println(categoryList);
//
//    }

}
