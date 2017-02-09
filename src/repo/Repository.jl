module Repository

#using DBI
using SQLite
include("../config/constants.jl")

#SQLite.tables(db)
function get_db()
	return SQLite.DB(DB_PATH) #return db connection
end

end