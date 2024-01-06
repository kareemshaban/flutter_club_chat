class AppUser {
   final int id ;
   final String tag ;
   final String name ;
   final String img ;
   final int share_level_id ;
   final int karizma_level_id ;
   final int charging_level_id ;
   final String phone ;
   final String email ;
   final String password ;
   final int isChargingAgent ;
   final int isHostingAgent ;
   final DateTime registered_at ;
   final DateTime last_login ;
   final DateTime birth_date ;
   final int enable ;
   final String ipAddress ;
   final String macAddress ;
   final String deviceId ;
   final int isOnline ;
   final int isInRoom ;
   final int country ;
   final String register_with ;


   AppUser(this.id, this.tag, this.name, this.img, this.share_level_id, this.karizma_level_id, this.charging_level_id, this.phone, this.email, this.password, this.isChargingAgent, this.isHostingAgent, this.registered_at, this.last_login, this.birth_date, this.enable, this.ipAddress, this.macAddress, this.deviceId, this.isOnline, this.isInRoom, this.country, this.register_with){

   }

}