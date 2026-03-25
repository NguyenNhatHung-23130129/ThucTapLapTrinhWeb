package vn.edu.hcmuaf.fit.doanweb.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;

import java.util.List;

public class UserDao extends BaseDao {

    // kiem tra email da ton tai chua
    public boolean checkEmailExist(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        int count = this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
        return count > 0;
    }
    public User login(String email, String pass) {
        String sql = "SELECT * FROM users WHERE email = ? AND BINARY password = ? AND is_verified = 1";
        return this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .bind(1, pass)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void register(User u) {
        String sql = "INSERT INTO users (email, password, verification_token, is_verified, role_id, created_at, name ,image_url) " +
                "VALUES (:email, :password, :token, 0, 3, NOW(), :name, :imageUrl)";

        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("email", u.getEmail())
                        .bind("password", u.getPassword())
                        .bind("token", u.getVerificationToken())
                        .bind("name", u.getName())
                        .bind("imageUrl", u.getImageUrl())
                        .execute()
        );
    }

    public boolean verifyAccount(String token) {
        String sql = "UPDATE users SET is_verified = 1, verification_token = NULL WHERE verification_token = :token";
        int rows = this.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("token", token)
                        .execute()
        );
        return rows > 0;
    }
    public void addUser(User u) {
        get().useTransaction(handle -> {
            int userId = handle.createUpdate("INSERT INTO users (name, email, password, phone, created_at, role_id, image_url) VALUES (:name, :email, :password, :phone, :createdAt, :roleId, :imageUrl)")
                    .bind("name", u.getName())
                    .bind("email", u.getEmail())
                    .bind("password", u.getPassword())
                    .bind("phone", u.getPhone())
                    .bind("createdAt", u.getCreatedAt())
                    .bind("roleId", u.getRoleId())
                    .bind("imageUrl", u.getImageUrl())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            if (u.getRoleId() == 2) {
                List<Integer> resourceIds = handle.createQuery("SELECT id FROM resources")
                        .mapTo(Integer.class)
                        .list();

                PreparedBatch batch = handle.prepareBatch("INSERT INTO permissions (rs_id,u_id, per) VALUES (:rsId,:uid, :per)");

                for (Integer rsId : resourceIds) {
                    batch.bind("rsId", rsId)
                            .bind("uid", userId)
                            .bind("per", 2)
                            .add();
                }
                batch.execute();
            }
        });
    }

    public List<User> getAllUsers() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM users")
                .mapToBean(User.class)
                .list()
        );
    }

    public void deleteUser(List<Integer> listId){
        get().useHandle(handle -> {
            PreparedBatch batch = handle.prepareBatch("DELETE FROM users WHERE id = :id");
            for (Integer id : listId) {
                batch.bind("id", id)
                        .add();
            }
            batch.execute();
        });
    }

    public void deleteUserById(int id) {
        get().useHandle(handle -> {
            handle.createUpdate("DELETE FROM users WHERE id = :id")
                    .bind("id", id).execute();
        });
    }

    public User getUserById(int id) {
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE id = ?")
                        .bind(0, id)
                        .mapToBean(User.class)
                        .findFirst()
                        .orElse(null)
        );
    }

    public void updateUser(User u) {
        get().useTransaction(handle -> {
            String sql = "UPDATE users SET name = :name, email = :email, phone = :phone, role_id = :roleId WHERE id = :id";

            handle.createUpdate(sql)
                    .bind("name", u.getName())
                    .bind("email", u.getEmail())
                    .bind("phone", u.getPhone())
                    .bind("roleId", u.getRoleId())
                    .bind("id", u.getId())
                    .execute();
            if (u.getRoleId() == 2) {

                handle.createUpdate("DELETE FROM permissions WHERE u_id = :uid")
                        .bind("uid", u.getId())
                        .execute();

                List<Integer> resourceIds = handle.createQuery("SELECT id FROM resources")
                        .mapTo(Integer.class)
                        .list();

                PreparedBatch batch = handle.prepareBatch("INSERT INTO permissions (rs_id,u_id, per) VALUES ( :rsId, :uid, :per)");
                for (Integer rsId : resourceIds) {
                    batch.bind("rsId", rsId)
                            .bind("uid", u.getId())
                            .bind("per", 2)
                            .add();
                }
                batch.execute();

            } else {
                handle.createUpdate("DELETE FROM permissions WHERE u_id = :uid")
                        .bind("uid", u.getId())
                        .execute();
            }
        });
    }



    public UserAdderss getUserAddressById(int userId) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM user_address WHERE user_id = :userId")
                .bind("userId", userId)
                .mapToBean(UserAdderss.class)
                .findOne()
                .orElse(null)
        );
    }
    public List<User> searchUsers(String keyword) {
        String searchTerm = "%" + keyword + "%";
        return get().withHandle(handle ->
                handle.createQuery("SELECT * FROM users WHERE name LIKE :keyword OR email LIKE :keyword OR phone LIKE :keyword")
                        .bind("keyword", searchTerm)
                        .mapToBean(User.class)
                        .list()
        );
    }
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        return this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .mapToBean(User.class)
                        .findOne()
                        .orElse(null)
        );
    }

    public void registerGoogle(String email, String name, String uid, String avatar) {
        String sql = "INSERT INTO users (email, name, firebase_uid, image_url, role_id, auth_provider, created_at, is_verified) " +
                "VALUES (:email, :name, :uid, :avatar, 3, 'google', NOW(), 1)";

        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("email", email)
                        .bind("name", name)
                        .bind("uid", uid)
                        .bind("avatar", avatar)
                        .execute()
        );
    }



    public void addUserFromAdmin(User u) {
        get().useTransaction(handle -> {
            int userId = handle.createUpdate("INSERT INTO users (name, email, password, phone, created_at, role_id, image_url, verification_token, is_verified) " +
                            "VALUES (:name, :email, :password, :phone, :createdAt, :roleId, :imageUrl, :token, 0)")
                    .bind("name", u.getName())
                    .bind("email", u.getEmail())
                    .bind("password", u.getPassword())
                    .bind("phone", u.getPhone())
                    .bind("createdAt", u.getCreatedAt())
                    .bind("roleId", u.getRoleId())
                    .bind("imageUrl", u.getImageUrl())
                    .bind("token", u.getVerificationToken())
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            if (u.getRoleId() == 2) {
                List<Integer> resourceIds = handle.createQuery("SELECT id FROM resources")
                        .mapTo(Integer.class)
                        .list();

                PreparedBatch batch = handle.prepareBatch("INSERT INTO permissions (rs_id, u_id, per) VALUES (:rsId, :uid, :per)");
                for (Integer rsId : resourceIds) {
                    batch.bind("rsId", rsId)
                            .bind("uid", userId)
                            .bind("per", 2)
                            .add();
                }
                batch.execute();
            }
        });
    }
    public void updateContact(int userId, String name, String phone) {
        get().useHandle(handle ->
                handle.createUpdate("UPDATE users SET name = :name, phone = :phone WHERE id = :id")
                        .bind("name", name)
                        .bind("phone", phone)
                        .bind("id", userId)
                        .execute()
        );
    }
    public void updatePassword(String email, String newPassword) {
        String sql = "UPDATE users SET password = :password WHERE email = :email";
        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("password", newPassword)
                        .bind("email", email)
                        .execute()
        );
    }

    // kiem tra tai khoan da duoc kich hoat chua
    public boolean isAccountActive(String email) {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND is_verified = 1";
        int count = this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
        return count > 0;
    }
}