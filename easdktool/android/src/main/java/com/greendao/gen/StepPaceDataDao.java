package com.greendao.gen;

import android.database.Cursor;
import android.database.sqlite.SQLiteStatement;

import org.greenrobot.greendao.AbstractDao;
import org.greenrobot.greendao.Property;
import org.greenrobot.greendao.internal.DaoConfig;
import org.greenrobot.greendao.database.Database;
import org.greenrobot.greendao.database.DatabaseStatement;

import com.example.easdktool.db.StepPaceData;

// THIS CODE IS GENERATED BY greenDAO, DO NOT EDIT.
/** 
 * DAO for table "STEP_PACE_DATA".
*/
public class StepPaceDataDao extends AbstractDao<StepPaceData, Long> {

    public static final String TABLENAME = "STEP_PACE_DATA";

    /**
     * Properties of entity StepPaceData.<br/>
     * Can be used for QueryBuilder and for referencing column names.
     */
    public static class Properties {
        public final static Property Time_stamp = new Property(0, long.class, "time_stamp", true, "_id");
        public final static Property Step_pace_value = new Property(1, int.class, "step_pace_value", false, "STEP_PACE_VALUE");
    }


    public StepPaceDataDao(DaoConfig config) {
        super(config);
    }
    
    public StepPaceDataDao(DaoConfig config, DaoSession daoSession) {
        super(config, daoSession);
    }

    /** Creates the underlying database table. */
    public static void createTable(Database db, boolean ifNotExists) {
        String constraint = ifNotExists? "IF NOT EXISTS ": "";
        db.execSQL("CREATE TABLE " + constraint + "\"STEP_PACE_DATA\" (" + //
                "\"_id\" INTEGER PRIMARY KEY NOT NULL ," + // 0: time_stamp
                "\"STEP_PACE_VALUE\" INTEGER NOT NULL );"); // 1: step_pace_value
    }

    /** Drops the underlying database table. */
    public static void dropTable(Database db, boolean ifExists) {
        String sql = "DROP TABLE " + (ifExists ? "IF EXISTS " : "") + "\"STEP_PACE_DATA\"";
        db.execSQL(sql);
    }

    @Override
    protected final void bindValues(DatabaseStatement stmt, StepPaceData entity) {
        stmt.clearBindings();
        stmt.bindLong(1, entity.getTime_stamp());
        stmt.bindLong(2, entity.getStep_pace_value());
    }

    @Override
    protected final void bindValues(SQLiteStatement stmt, StepPaceData entity) {
        stmt.clearBindings();
        stmt.bindLong(1, entity.getTime_stamp());
        stmt.bindLong(2, entity.getStep_pace_value());
    }

    @Override
    public Long readKey(Cursor cursor, int offset) {
        return cursor.getLong(offset + 0);
    }    

    @Override
    public StepPaceData readEntity(Cursor cursor, int offset) {
        StepPaceData entity = new StepPaceData( //
            cursor.getLong(offset + 0), // time_stamp
            cursor.getInt(offset + 1) // step_pace_value
        );
        return entity;
    }
     
    @Override
    public void readEntity(Cursor cursor, StepPaceData entity, int offset) {
        entity.setTime_stamp(cursor.getLong(offset + 0));
        entity.setStep_pace_value(cursor.getInt(offset + 1));
     }
    
    @Override
    protected final Long updateKeyAfterInsert(StepPaceData entity, long rowId) {
        entity.setTime_stamp(rowId);
        return rowId;
    }
    
    @Override
    public Long getKey(StepPaceData entity) {
        if(entity != null) {
            return entity.getTime_stamp();
        } else {
            return null;
        }
    }

    @Override
    public boolean hasKey(StepPaceData entity) {
        throw new UnsupportedOperationException("Unsupported for entities with a non-null key");
    }

    @Override
    protected final boolean isEntityUpdateable() {
        return true;
    }
    
}
