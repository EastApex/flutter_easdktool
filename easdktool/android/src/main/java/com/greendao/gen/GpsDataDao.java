package com.greendao.gen;

import android.database.Cursor;
import android.database.sqlite.SQLiteStatement;

import org.greenrobot.greendao.AbstractDao;
import org.greenrobot.greendao.Property;
import org.greenrobot.greendao.internal.DaoConfig;
import org.greenrobot.greendao.database.Database;
import org.greenrobot.greendao.database.DatabaseStatement;

import com.example.easdktool.db.GpsData;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.
/** 
 * DAO for table "GPS_DATA".
*/
public class GpsDataDao extends AbstractDao<GpsData, Long> {

    public static final String TABLENAME = "GPS_DATA";

    /**
     * Properties of entity GpsData.<br/>
     * Can be used for QueryBuilder and for referencing column names.
     */
    public static class Properties {
        public final static Property Time_stamp = new Property(0, long.class, "time_stamp", true, "_id");
        public final static Property Latitude = new Property(1, double.class, "latitude", false, "LATITUDE");
        public final static Property Longitude = new Property(2, double.class, "longitude", false, "LONGITUDE");
    }


    public GpsDataDao(DaoConfig config) {
        super(config);
    }
    
    public GpsDataDao(DaoConfig config, DaoSession daoSession) {
        super(config, daoSession);
    }

    /** Creates the underlying database table. */
    public static void createTable(Database db, boolean ifNotExists) {
        String constraint = ifNotExists? "IF NOT EXISTS ": "";
        db.execSQL("CREATE TABLE " + constraint + "\"GPS_DATA\" (" + //
                "\"_id\" INTEGER PRIMARY KEY NOT NULL ," + // 0: time_stamp
                "\"LATITUDE\" REAL NOT NULL ," + // 1: latitude
                "\"LONGITUDE\" REAL NOT NULL );"); // 2: longitude
    }

    /** Drops the underlying database table. */
    public static void dropTable(Database db, boolean ifExists) {
        String sql = "DROP TABLE " + (ifExists ? "IF EXISTS " : "") + "\"GPS_DATA\"";
        db.execSQL(sql);
    }

    @Override
    protected final void bindValues(DatabaseStatement stmt, GpsData entity) {
        stmt.clearBindings();
        stmt.bindLong(1, entity.getTime_stamp());
        stmt.bindDouble(2, entity.getLatitude());
        stmt.bindDouble(3, entity.getLongitude());
    }

    @Override
    protected final void bindValues(SQLiteStatement stmt, GpsData entity) {
        stmt.clearBindings();
        stmt.bindLong(1, entity.getTime_stamp());
        stmt.bindDouble(2, entity.getLatitude());
        stmt.bindDouble(3, entity.getLongitude());
    }

    @Override
    public Long readKey(Cursor cursor, int offset) {
        return cursor.getLong(offset + 0);
    }    

    @Override
    public GpsData readEntity(Cursor cursor, int offset) {
        GpsData entity = new GpsData( //
            cursor.getLong(offset + 0), // time_stamp
            cursor.getDouble(offset + 1), // latitude
            cursor.getDouble(offset + 2) // longitude
        );
        return entity;
    }
     
    @Override
    public void readEntity(Cursor cursor, GpsData entity, int offset) {
        entity.setTime_stamp(cursor.getLong(offset + 0));
        entity.setLatitude(cursor.getDouble(offset + 1));
        entity.setLongitude(cursor.getDouble(offset + 2));
     }
    
    @Override
    protected final Long updateKeyAfterInsert(GpsData entity, long rowId) {
        entity.setTime_stamp(rowId);
        return rowId;
    }
    
    @Override
    public Long getKey(GpsData entity) {
        if(entity != null) {
            return entity.getTime_stamp();
        } else {
            return null;
        }
    }

    @Override
    public boolean hasKey(GpsData entity) {
        throw new UnsupportedOperationException("Unsupported for entities with a non-null key");
    }

    @Override
    protected final boolean isEntityUpdateable() {
        return true;
    }
    
}
