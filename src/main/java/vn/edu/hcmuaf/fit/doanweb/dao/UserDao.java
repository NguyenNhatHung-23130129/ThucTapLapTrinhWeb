package vn.edu.hcmuaf.fit.doanweb.dao;

import org.jdbi.v3.core.statement.PreparedBatch;
import vn.edu.hcmuaf.fit.doanweb.model.User;
import vn.edu.hcmuaf.fit.doanweb.model.UserAdderss;

import java.util.List;
import java.util.Optional;

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
        String sql = "SELECT * FROM users WHERE email = ? AND BINARY password = ? AND is_verified = 1 AND active = 1";
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
        this.get().useTransaction(handle -> {
                    int defaultRoleId = handle.createQuery("SELECT id FROM role WHERE role_key = 'user'")
                            .mapTo(Integer.class)
                            .findOne()
                            .orElse(3);
                    String sql = "INSERT INTO users (email, password, verification_token, is_verified, role_id, created_at, name ,image_url, active) " +
                            "VALUES (:email, :password, :token, 0, :roleId, NOW(), :name, :imageUrl,:active)";

                    int userId = handle.createUpdate(sql)
                            .bind("email", u.getEmail())
                            .bind("password", u.getPassword())
                            .bind("token", u.getVerificationToken())
                            .bind("name", u.getName())
                            .bind("imageUrl", u.getImageUrl())
                            .bind("roleId", defaultRoleId)
                            .bind("active", u.isActive() ? 1 : 0)
                            .executeAndReturnGeneratedKeys("id")
                            .mapTo(Integer.class)
                            .one();
                    handle.createUpdate("INSERT INTO user_roles (user_id, role_id) VALUES (:userId, :roleId)")
                            .bind("userId", userId)
                            .bind("roleId", defaultRoleId)
                            .execute();
                }
        );
    }

    public boolean verifyAccount(String token) {
        String sql = "UPDATE users SET is_verified = 1, active = 1, verification_token = NULL WHERE verification_token = :token";
        int rows = this.get().withHandle(handle ->
                handle.createUpdate(sql)
                        .bind("token", token)
                        .execute()
        );
        return rows > 0;
    }

    public List<User> getAllUsers() {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM users order by created_at desc, id desc")
                .mapToBean(User.class)
                .list()
        );
    }

    public void deleteUserById(int id) {
        get().useHandle(handle -> {
            handle.createUpdate("UPDATE users SET active = 0 WHERE id = :id")
                    .bind("id", id).execute();
        });
    }


    public void updateUser(User u) {
        get().useTransaction(handle -> {
            String sql = "UPDATE users SET name = :name, email = :email, phone = :phone, role_id = :roleId, active = :active, image_url = :imageUrl WHERE id = :id";

            handle.createUpdate(sql)
                    .bind("name", u.getName())
                    .bind("email", u.getEmail())
                    .bind("phone", u.getPhone())
                    .bind("roleId", u.getRoleId())
                    .bind("active", u.isActive() ? 1 : 0)
                    .bind("imageUrl", u.getImageUrl())
                    .bind("id", u.getId())
                    .execute();

            if (u.getRoleId() > 0) {
                handle.createUpdate("DELETE FROM user_roles WHERE user_id = :userId")
                        .bind("userId", u.getId())
                        .execute();

                handle.createUpdate("INSERT INTO user_roles (user_id, role_id) VALUES (:userId, :roleId)")
                        .bind("userId", u.getId())
                        .bind("roleId", u.getRoleId())
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
        this.get().useTransaction(handle -> {
            int defaultRoleId = handle.createQuery("SELECT id FROM role WHERE role_key = 'user'")
                    .mapTo(Integer.class)
                    .findOne()
                    .orElse(3);

            String sql = "INSERT INTO users (email, name, firebase_uid, image_url, role_id, auth_provider, created_at, is_verified, active) " +
                    "VALUES (:email, :name, :uid, :avatar, :roleId, 'google', NOW(), 1, 1)";

            int userId = handle.createUpdate(sql)
                    .bind("email", email)
                    .bind("name", name)
                    .bind("uid", uid)
                    .bind("avatar", avatar)
                    .bind("roleId", defaultRoleId)
                    .executeAndReturnGeneratedKeys("id")
                    .mapTo(Integer.class)
                    .one();

            handle.createUpdate("INSERT INTO user_roles (user_id, role_id) VALUES (:userId, :roleId)")
                    .bind("userId", userId)
                    .bind("roleId", defaultRoleId)
                    .execute();
        });
    }


    public void addUserFromAdmin(User u) {
        get().useTransaction(handle -> {
            int userId = handle.createUpdate("INSERT INTO users (name, email, password, phone, created_at, role_id, image_url, verification_token, is_verified, active) " +
                            "VALUES (:name, :email, :password, :phone, :createdAt, :roleId, :imageUrl, :token, 0,0)")
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


            if (u.getRoleId() > 0) {
                Optional<Integer> roleExists = handle.createQuery("SELECT id FROM role WHERE id = :roleId")
                        .bind("roleId", u.getRoleId())
                        .mapTo(Integer.class)
                        .findFirst();


                if (roleExists.isPresent()) {
                    handle.createUpdate("INSERT INTO user_roles (user_id, role_id) VALUES (:userId, :roleId)")
                            .bind("userId", userId)
                            .bind("roleId", u.getRoleId())
                            .execute();
                }
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
        String sql = "SELECT COUNT(*) FROM users WHERE email = ? AND is_verified = 1 AND active = 1";
        int count = this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind(0, email)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
        return count > 0;
    }

    public void updateGoogleAvatar(String email, String avatar) {
        String sql = "UPDATE users SET image_url = :avatar WHERE email = :email";

        this.get().useHandle(handle ->
                handle.createUpdate(sql)
                        .bind("avatar", avatar)
                        .bind("email", email)
                        .execute()
        );
    }

    public User getUserById(int id) {
        return get().withHandle(handle -> handle.createQuery("SELECT * FROM users WHERE id = :id")
                .bind("id", id)
                .mapToBean(User.class)
                .findOne()
                .orElse(null)
        );
    }
    public boolean isLastAdmin(int userId) {
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = 1 AND active = 1";
        int count = this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );

        if (count == 1) {
            User user = getUserById(userId);
            return user != null && user.getRoleId() == 1;
        }
        return false;
    }

    public boolean hasUnfinishedOrders(int userId) {
        String sql = "SELECT COUNT(*) FROM orders WHERE user_id = :userId " +
                "AND status NOT IN ('Đã giao', 'Đã hủy')";

        int count = this.get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("userId", userId)
                        .mapTo(Integer.class)
                        .findOne()
                        .orElse(0)
        );
        return count > 0;
    }

    public String getRoleNameById(int roleId) {
        String sql = "SELECT name FROM role WHERE id = :roleId";
        return get().withHandle(handle ->
                handle.createQuery(sql)
                        .bind("roleId", roleId)
                        .mapTo(String.class)
                        .findOne()
                        .orElse("Khách hàng")
        );
    }
}