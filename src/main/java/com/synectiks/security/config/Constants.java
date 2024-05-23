package com.synectiks.security.config;

import java.util.HashMap;
import java.util.Map;

/**
 * Application constants.
 */
public final class Constants {

    public static final String SYSTEM_ACCOUNT = "System";
    public static final String ACTIVE = "ACTIVE";
    public static final String DEACTIVE = "DEACTIVE";
    public static final String USER_TYPE_USER = "USER";
    public static final String USER_TYPE_ADMIN = "ADMIN";
    public static final String USER_TYPE_SUPER_ADMIN = "Super Admins";

    public static final String USER_TYPE_ORG_USER = "ORG_USER";
    public static final String USER_TYPE_ROOT = "ROOT";

    public static final String USER_INVITE_SENT = "INVITE_SENT";
    public static final String USER_INVITE_ACCEPTENCE_PENDING = "PENDING";
    public static final String USER_INVITE_CANCELED = "CANCELED";
    public static final String USER_INVITE_ACCEPTED = "ACCEPTED";
    public static final String YES = "YES";
    public static final String NO = "NO";
    public static final String FILE_TYPE_IMAGE = "IMAGE";
    public static final String LOCAL_PROFILE_IMAGE_STORAGE_DIRECTORY = "profile_images";
    public static final String FILE_STORAGE_LOCATION_LOCAL = "LOCAL";
    public static final String IDENTIFIER_PROFILE_IMAGE = "PROFILE_IMAGE";
    public static String HOST = null;
    public static String PORT = null;

    public static String STATUS_PENDING = "PENDING";
    public static String STATUS_FAILED = "FAILED";
    public static String STATUS_SENT = "SENT";
    public static String STATUS_IN_PROCESS = "IN_PROCESS";
    public static String STATUS_ACCEPTED = "ACCEPTED";
    public static String STATUS_REJECTED = "REJECTED";
    public static String STATUS_NEW = "NEW";
    public static String STATUS_LOCKED = "LOCKED";
    public static String STATUS_TERMINATED = "TERMINATED";
    public static String STATUS_SUSPENDED = "SUSPENDED";

    public static String APPROVE = "APPROVE";
    public static String DENY = "DENY";
    public static String TYPE_NEW_USER = "NEW_USER";

    public static String DEFAULT_ORGANIZATION = "SYNECTIKS";
    public static String GLOBAL_AWS_ACCESS_KEY = "GLOBAL_AWS_ACCESS_KEY";
    public static String GLOBAL_AWS_SECRET_KEY = "GLOBAL_AWS_SECRET_KEY";
    public static String GLOBAL_AWS_REGION = "GLOBAL_AWS_REGION";
    public static String GLOBAL_AWS_S3_BUCKET_NAME_FOR_USER_IMAGES = "GLOBAL_AWS_S3_BUCKET_NAME_FOR_USER_IMAGES";
    public static String GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_USER_IMAGES = "GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_USER_IMAGES";
    public static String GLOBAL_AWS_S3_BUCKET_NAME_FOR_ORG_PROFILE_IMAGES = "GLOBAL_AWS_S3_BUCKET_NAME_FOR_ORG_PROFILE_IMAGES";
    public static String GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_ORG_PROFILE_IMAGES = "GLOBAL_AWS_S3_FOLDER_LOCATION_FOR_ORG_PROFILE_IMAGES";
    public static String GLOBAL_AWS_EMAIL_END_POINT = "GLOBAL_AWS_EMAIL_END_POINT";
    public static String GLOBAL_APPKUBE_EMAIL_SENDER = "GLOBAL_APPKUBE_EMAIL_SENDER";
    public static String MAIL_SUBJECT_NEW_APPKUBE_ACCOUNT_CREATED = "New AppKube Account Created";
    public static String MAIL_BODY_NEW_APPKUBE_ACCOUNT_CREATED = "Dear <h3>##USERNAME##</h3>,<br>" +
        "Welcome to AppKube. We're delighted to have you on board.<br>" +
        "As part of the onboarding process, we are providing you with your login credentials to access AppKube services. Please keep this information secure and do not share it with anyone.<br>" +
        "<br>" +
        "Your login details are as follows:<br>" +
        "Login ID: <h3>##USERNAME##</h3><br>" +
        "Password: <h3>##PASSWORD##</h3><br>" +
        "<br>" +
        "You can use the below link to login<br>" +
        "<br>" +
        "<a href=\"https://appkube.synectiks.net\">https://appkube.synectiks.net</a> <br>" +
        "<br>" +
        "Best regards,<br><h3>##OWNERNAME##</h3>";

    public static String MAIL_SUBJECT_NEW_ORG_USER_REQUEST = "New User Registration Request In AppKube";
    public static String MAIL_BODY_NEW_ORG_USER_REQUEST = "Dear <h3>##USERNAME##</h3>,<br>" +
        "Welcome to AppKube.<br>" +
        "Your request to register yourself as AppKube user has been registered.<br>" +
        "<br>" +
        "Status of your request will be notified in further mails.<br>" +
        "<br>" +
        "Best regards,<br><h3>##OWNERNAME##</h3>";

    public static String CMDB_ORGANIZATION_URL = "CMDB_ORGANIZATION_URL";
    public static String GLOBAL_SESSION_TIMEOUT = "GLOBAL_SESSION_TIMEOUT";

    public static String TYPE_NEW_ORG_USER_REQUEST = "NEW_ORG_USER_REQUEST";
    public static String USER_REQUEST_TYPE_ONLINE = "ONLINE";
    public static String USER_REQUEST_TYPE_EMAIL = "EMAIL";
    public static String USER_REQUEST_TYPE_APPKUBE = "APPKUBE";

    public static String SUCCESS = "SUCCESS";
    public static String ERROR = "ERROR";

    public static String ROLE_DEFAULT_USERS = "Default Users";
    public static String DEFAULT_TARGET_SERVICE = "CMDB";
    private Constants() {

    }
//    public static Map<String, Object> UserCache = new HashMap<>();
}
