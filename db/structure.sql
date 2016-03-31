--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: china_cities_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE china_cities_hours (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    quality character varying(255),
    weather character varying(255),
    temp character varying(255),
    humi character varying(255),
    winddirection character varying(255),
    windspeed character varying(255),
    windscale integer,
    zonghezhishu double precision,
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: china_cities_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE china_cities_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: china_cities_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE china_cities_hours_id_seq OWNED BY china_cities_hours.id;


--
-- Name: cities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE cities (
    id integer NOT NULL,
    city_name character varying(255),
    city_name_pinyin character varying(255),
    post_number integer,
    latitude double precision,
    lonlat geography(Point,4326),
    longitude double precision,
    cityid integer
);


--
-- Name: cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE cities_id_seq OWNED BY cities.id;


--
-- Name: counties; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE counties (
    id integer NOT NULL,
    name character varying(255),
    area double precision,
    perimeter double precision,
    adcode integer,
    centroid_y double precision,
    centroid_x double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    boundary geometry(MultiPolygon)
);


--
-- Name: counties_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE counties_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: counties_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE counties_id_seq OWNED BY counties.id;


--
-- Name: day_cities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE day_cities (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: day_cities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE day_cities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: day_cities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE day_cities_id_seq OWNED BY day_cities.id;


--
-- Name: forecast_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forecast_points (
    id integer NOT NULL,
    publish_date timestamp without time zone,
    forecast_date timestamp without time zone,
    pm25 double precision,
    pm10 double precision,
    "SO2" double precision,
    "CO" double precision,
    "NO2" double precision,
    "O3" double precision,
    "AQI" double precision,
    "VIS" double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    latlon geography(Point,4326),
    longitude double precision,
    latitude double precision
);


--
-- Name: forecast_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forecast_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forecast_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forecast_points_id_seq OWNED BY forecast_points.id;


--
-- Name: forecasts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE forecasts (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    "AQI" double precision,
    quality character varying(255),
    main_pollutant character varying(255),
    weather character varying(255),
    temp character varying(255),
    humi character varying(255),
    winddirection character varying(255),
    windspeed character varying(255),
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE forecasts_id_seq OWNED BY forecasts.id;


--
-- Name: hourly_city_forecast_air_qualities; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE hourly_city_forecast_air_qualities (
    id integer NOT NULL,
    city_id integer,
    publish_datetime timestamp without time zone,
    forecast_datetime timestamp without time zone,
    "AQI" double precision,
    main_pol character varying(255),
    grade integer,
    pm25 double precision,
    pm10 double precision,
    "SO2" double precision,
    "CO" double precision,
    "NO2" double precision,
    "O3" double precision,
    "VIS" double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: hourly_city_forecast_air_qualities_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE hourly_city_forecast_air_qualities_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: hourly_city_forecast_air_qualities_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE hourly_city_forecast_air_qualities_id_seq OWNED BY hourly_city_forecast_air_qualities.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE locations (
    id integer NOT NULL,
    name character varying(255),
    latlon geography(Point,4326),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE locations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE locations_id_seq OWNED BY locations.id;


--
-- Name: monitor_points; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE monitor_points (
    id integer NOT NULL,
    region character varying(255),
    pointname character varying(255),
    level character varying(255),
    latitude double precision,
    longitude double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    city_id integer,
    post_number integer
);


--
-- Name: monitor_points_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE monitor_points_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monitor_points_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE monitor_points_id_seq OWNED BY monitor_points.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


--
-- Name: temp_bd_days; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_bd_days (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    data_real_time timestamp without time zone,
    weather character varying(255),
    temp integer,
    humi integer,
    winddirection character varying(255),
    windspeed integer,
    windscale integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: temp_bd_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_bd_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_bd_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_bd_days_id_seq OWNED BY temp_bd_days.id;


--
-- Name: temp_bd_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_bd_hours (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    weather character varying(255),
    winddirection character varying(255),
    data_real_time timestamp without time zone,
    zonghezhishu double precision,
    windscale integer,
    windspeed integer,
    humi integer,
    temp integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: temp_bd_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_bd_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_bd_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_bd_hours_id_seq OWNED BY temp_bd_hours.id;


--
-- Name: temp_bd_months; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_bd_months (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: temp_bd_months_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_bd_months_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_bd_months_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_bd_months_id_seq OWNED BY temp_bd_months.id;


--
-- Name: temp_bd_years; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_bd_years (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: temp_bd_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_bd_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_bd_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_bd_years_id_seq OWNED BY temp_bd_years.id;


--
-- Name: temp_hb_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_hb_hours (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    weather character varying(255),
    winddirection character varying(255),
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    zonghezhishu double precision,
    windscale integer,
    windspeed integer,
    humi integer,
    temp integer
);


--
-- Name: temp_hb_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_hb_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_hb_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_hb_hours_id_seq OWNED BY temp_hb_hours.id;


--
-- Name: temp_hourly_forecasts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_hourly_forecasts (
    id integer NOT NULL,
    city_id integer,
    publish_datetime timestamp without time zone,
    forecast_datetime timestamp without time zone,
    "AQI" double precision,
    main_pol character varying(255),
    grade integer,
    pm25 double precision,
    pm10 double precision,
    "SO2" double precision,
    "CO" double precision,
    "NO2" double precision,
    "O3" double precision,
    "VIS" double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: temp_hourly_forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_hourly_forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_hourly_forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_hourly_forecasts_id_seq OWNED BY temp_hourly_forecasts.id;


--
-- Name: temp_jjj_days; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_jjj_days (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    weather character varying(255),
    temp integer,
    humi integer,
    winddirection character varying(255),
    windspeed integer,
    windscale integer
);


--
-- Name: temp_jjj_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_jjj_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_jjj_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_jjj_days_id_seq OWNED BY temp_jjj_days.id;


--
-- Name: temp_jjj_months; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_jjj_months (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    maxindex integer
);


--
-- Name: temp_jjj_months_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_jjj_months_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_jjj_months_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_jjj_months_id_seq OWNED BY temp_jjj_months.id;


--
-- Name: temp_jjj_years; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_jjj_years (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    maxindex integer
);


--
-- Name: temp_jjj_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_jjj_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_jjj_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_jjj_years_id_seq OWNED BY temp_jjj_years.id;


--
-- Name: temp_lf_days; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_lf_days (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    weather character varying(255),
    temp integer,
    humi integer,
    winddirection character varying(255),
    windspeed integer,
    windscale integer
);


--
-- Name: temp_lf_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_lf_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_lf_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_lf_days_id_seq OWNED BY temp_lf_days.id;


--
-- Name: temp_lf_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_lf_hours (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    weather character varying(255),
    winddirection character varying(255),
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    zonghezhishu double precision,
    windscale integer,
    windspeed integer,
    humi integer,
    temp integer
);


--
-- Name: temp_lf_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_lf_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_lf_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_lf_hours_id_seq OWNED BY temp_lf_hours.id;


--
-- Name: temp_lf_months; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_lf_months (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone
);


--
-- Name: temp_lf_months_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_lf_months_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_lf_months_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_lf_months_id_seq OWNED BY temp_lf_months.id;


--
-- Name: temp_lf_years; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_lf_years (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone
);


--
-- Name: temp_lf_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_lf_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_lf_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_lf_years_id_seq OWNED BY temp_lf_years.id;


--
-- Name: temp_sfcities_days; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_sfcities_days (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    weather character varying(255),
    temp integer,
    humi integer,
    winddirection character varying(255),
    windspeed integer,
    windscale integer
);


--
-- Name: temp_sfcities_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_sfcities_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_sfcities_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_sfcities_days_id_seq OWNED BY temp_sfcities_days.id;


--
-- Name: temp_sfcities_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_sfcities_hours (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    weather character varying(255),
    winddirection character varying(255),
    data_real_time timestamp without time zone,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    zonghezhishu double precision,
    windscale integer,
    windspeed integer,
    humi integer,
    temp integer
);


--
-- Name: temp_sfcities_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_sfcities_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_sfcities_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_sfcities_hours_id_seq OWNED BY temp_sfcities_hours.id;


--
-- Name: temp_sfcities_months; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_sfcities_months (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    maxindex integer
);


--
-- Name: temp_sfcities_months_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_sfcities_months_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_sfcities_months_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_sfcities_months_id_seq OWNED BY temp_sfcities_months.id;


--
-- Name: temp_sfcities_years; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE temp_sfcities_years (
    id integer NOT NULL,
    city_id integer,
    "SO2" double precision,
    "NO2" double precision,
    "CO" double precision,
    "O3" double precision,
    pm10 double precision,
    pm25 double precision,
    zonghezhishu double precision,
    "AQI" double precision,
    level character varying(255),
    main_pol character varying(255),
    "SO2_change_rate" double precision,
    "NO2_change_rate" double precision,
    "CO_change_rate" double precision,
    "O3_change_rate" double precision,
    pm10_change_rate double precision,
    pm25_change_rate double precision,
    zongheindex_change_rate double precision,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    data_real_time timestamp without time zone,
    maxindex integer
);


--
-- Name: temp_sfcities_years_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE temp_sfcities_years_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: temp_sfcities_years_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE temp_sfcities_years_id_seq OWNED BY temp_sfcities_years.id;


--
-- Name: weather_days; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weather_days (
    id integer NOT NULL,
    city_id integer,
    publish_datetime timestamp without time zone,
    high character varying(255),
    low character varying(255),
    day_type character varying(255),
    day_fx character varying(255),
    day_fl character varying(255),
    night_type character varying(255),
    night_fx character varying(255),
    night_fl character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: weather_days_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weather_days_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weather_days_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weather_days_id_seq OWNED BY weather_days.id;


--
-- Name: weather_forecasts; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weather_forecasts (
    id integer NOT NULL,
    city_id integer,
    publish_datetime timestamp without time zone,
    forecast_datetime timestamp without time zone,
    high character varying(255),
    low character varying(255),
    day_type character varying(255),
    day_fx character varying(255),
    day_fl character varying(255),
    night_type character varying(255),
    night_fx character varying(255),
    night_fl character varying(255),
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: weather_forecasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weather_forecasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weather_forecasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weather_forecasts_id_seq OWNED BY weather_forecasts.id;


--
-- Name: weather_hours; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE weather_hours (
    id integer NOT NULL,
    city_id integer,
    publish_datetime timestamp without time zone,
    wendu integer,
    fengli character varying(255),
    shidu character varying(255),
    fengxiang character varying(255),
    sunrise timestamp without time zone,
    sunset timestamp without time zone,
    zhishu text,
    created_at timestamp without time zone,
    updated_at timestamp without time zone
);


--
-- Name: weather_hours_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE weather_hours_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weather_hours_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE weather_hours_id_seq OWNED BY weather_hours.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY china_cities_hours ALTER COLUMN id SET DEFAULT nextval('china_cities_hours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY cities ALTER COLUMN id SET DEFAULT nextval('cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY counties ALTER COLUMN id SET DEFAULT nextval('counties_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY day_cities ALTER COLUMN id SET DEFAULT nextval('day_cities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forecast_points ALTER COLUMN id SET DEFAULT nextval('forecast_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY forecasts ALTER COLUMN id SET DEFAULT nextval('forecasts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY hourly_city_forecast_air_qualities ALTER COLUMN id SET DEFAULT nextval('hourly_city_forecast_air_qualities_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY locations ALTER COLUMN id SET DEFAULT nextval('locations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY monitor_points ALTER COLUMN id SET DEFAULT nextval('monitor_points_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_bd_days ALTER COLUMN id SET DEFAULT nextval('temp_bd_days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_bd_hours ALTER COLUMN id SET DEFAULT nextval('temp_bd_hours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_bd_months ALTER COLUMN id SET DEFAULT nextval('temp_bd_months_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_bd_years ALTER COLUMN id SET DEFAULT nextval('temp_bd_years_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_hb_hours ALTER COLUMN id SET DEFAULT nextval('temp_hb_hours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_hourly_forecasts ALTER COLUMN id SET DEFAULT nextval('temp_hourly_forecasts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_jjj_days ALTER COLUMN id SET DEFAULT nextval('temp_jjj_days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_jjj_months ALTER COLUMN id SET DEFAULT nextval('temp_jjj_months_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_jjj_years ALTER COLUMN id SET DEFAULT nextval('temp_jjj_years_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_lf_days ALTER COLUMN id SET DEFAULT nextval('temp_lf_days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_lf_hours ALTER COLUMN id SET DEFAULT nextval('temp_lf_hours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_lf_months ALTER COLUMN id SET DEFAULT nextval('temp_lf_months_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_lf_years ALTER COLUMN id SET DEFAULT nextval('temp_lf_years_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_sfcities_days ALTER COLUMN id SET DEFAULT nextval('temp_sfcities_days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_sfcities_hours ALTER COLUMN id SET DEFAULT nextval('temp_sfcities_hours_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_sfcities_months ALTER COLUMN id SET DEFAULT nextval('temp_sfcities_months_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY temp_sfcities_years ALTER COLUMN id SET DEFAULT nextval('temp_sfcities_years_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weather_days ALTER COLUMN id SET DEFAULT nextval('weather_days_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weather_forecasts ALTER COLUMN id SET DEFAULT nextval('weather_forecasts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY weather_hours ALTER COLUMN id SET DEFAULT nextval('weather_hours_id_seq'::regclass);


--
-- Name: china_cities_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY china_cities_hours
    ADD CONSTRAINT china_cities_hours_pkey PRIMARY KEY (id);


--
-- Name: cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY cities
    ADD CONSTRAINT cities_pkey PRIMARY KEY (id);


--
-- Name: counties_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY counties
    ADD CONSTRAINT counties_pkey PRIMARY KEY (id);


--
-- Name: day_cities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY day_cities
    ADD CONSTRAINT day_cities_pkey PRIMARY KEY (id);


--
-- Name: forecast_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forecast_points
    ADD CONSTRAINT forecast_points_pkey PRIMARY KEY (id);


--
-- Name: forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY forecasts
    ADD CONSTRAINT forecasts_pkey PRIMARY KEY (id);


--
-- Name: hourly_city_forecast_air_qualities_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY hourly_city_forecast_air_qualities
    ADD CONSTRAINT hourly_city_forecast_air_qualities_pkey PRIMARY KEY (id);


--
-- Name: locations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: monitor_points_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY monitor_points
    ADD CONSTRAINT monitor_points_pkey PRIMARY KEY (id);


--
-- Name: temp_bd_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_bd_days
    ADD CONSTRAINT temp_bd_days_pkey PRIMARY KEY (id);


--
-- Name: temp_bd_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_bd_hours
    ADD CONSTRAINT temp_bd_hours_pkey PRIMARY KEY (id);


--
-- Name: temp_bd_months_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_bd_months
    ADD CONSTRAINT temp_bd_months_pkey PRIMARY KEY (id);


--
-- Name: temp_bd_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_bd_years
    ADD CONSTRAINT temp_bd_years_pkey PRIMARY KEY (id);


--
-- Name: temp_hb_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_hb_hours
    ADD CONSTRAINT temp_hb_hours_pkey PRIMARY KEY (id);


--
-- Name: temp_hourly_forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_hourly_forecasts
    ADD CONSTRAINT temp_hourly_forecasts_pkey PRIMARY KEY (id);


--
-- Name: temp_jjj_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_jjj_days
    ADD CONSTRAINT temp_jjj_days_pkey PRIMARY KEY (id);


--
-- Name: temp_jjj_months_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_jjj_months
    ADD CONSTRAINT temp_jjj_months_pkey PRIMARY KEY (id);


--
-- Name: temp_jjj_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_jjj_years
    ADD CONSTRAINT temp_jjj_years_pkey PRIMARY KEY (id);


--
-- Name: temp_lf_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_lf_days
    ADD CONSTRAINT temp_lf_days_pkey PRIMARY KEY (id);


--
-- Name: temp_lf_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_lf_hours
    ADD CONSTRAINT temp_lf_hours_pkey PRIMARY KEY (id);


--
-- Name: temp_lf_months_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_lf_months
    ADD CONSTRAINT temp_lf_months_pkey PRIMARY KEY (id);


--
-- Name: temp_lf_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_lf_years
    ADD CONSTRAINT temp_lf_years_pkey PRIMARY KEY (id);


--
-- Name: temp_sfcities_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_sfcities_days
    ADD CONSTRAINT temp_sfcities_days_pkey PRIMARY KEY (id);


--
-- Name: temp_sfcities_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_sfcities_hours
    ADD CONSTRAINT temp_sfcities_hours_pkey PRIMARY KEY (id);


--
-- Name: temp_sfcities_months_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_sfcities_months
    ADD CONSTRAINT temp_sfcities_months_pkey PRIMARY KEY (id);


--
-- Name: temp_sfcities_years_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY temp_sfcities_years
    ADD CONSTRAINT temp_sfcities_years_pkey PRIMARY KEY (id);


--
-- Name: weather_days_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weather_days
    ADD CONSTRAINT weather_days_pkey PRIMARY KEY (id);


--
-- Name: weather_forecasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weather_forecasts
    ADD CONSTRAINT weather_forecasts_pkey PRIMARY KEY (id);


--
-- Name: weather_hours_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY weather_hours
    ADD CONSTRAINT weather_hours_pkey PRIMARY KEY (id);


--
-- Name: index_hourlyaqi_city_pubtime_foretime; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_hourlyaqi_city_pubtime_foretime ON hourly_city_forecast_air_qualities USING btree (city_id, publish_datetime, forecast_datetime);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- PostgreSQL database dump complete
--

SET search_path TO public,postgis;

INSERT INTO schema_migrations (version) VALUES ('20150307174131');

INSERT INTO schema_migrations (version) VALUES ('20150308022609');

INSERT INTO schema_migrations (version) VALUES ('20150310034006');

INSERT INTO schema_migrations (version) VALUES ('20150310153749');

INSERT INTO schema_migrations (version) VALUES ('20150317072002');

INSERT INTO schema_migrations (version) VALUES ('20150317083543');

INSERT INTO schema_migrations (version) VALUES ('20150331122834');

INSERT INTO schema_migrations (version) VALUES ('20150401152017');

INSERT INTO schema_migrations (version) VALUES ('20150403033734');

INSERT INTO schema_migrations (version) VALUES ('20150625140959');

INSERT INTO schema_migrations (version) VALUES ('20150712122810');

INSERT INTO schema_migrations (version) VALUES ('20150712130708');

INSERT INTO schema_migrations (version) VALUES ('20150712131702');

INSERT INTO schema_migrations (version) VALUES ('20150712132039');

INSERT INTO schema_migrations (version) VALUES ('20150712133102');

INSERT INTO schema_migrations (version) VALUES ('20150712133629');

INSERT INTO schema_migrations (version) VALUES ('20150712133925');

INSERT INTO schema_migrations (version) VALUES ('20150712134121');

INSERT INTO schema_migrations (version) VALUES ('20150712134439');

INSERT INTO schema_migrations (version) VALUES ('20150712134626');

INSERT INTO schema_migrations (version) VALUES ('20150712134742');

INSERT INTO schema_migrations (version) VALUES ('20150722061700');

INSERT INTO schema_migrations (version) VALUES ('20150722082144');

INSERT INTO schema_migrations (version) VALUES ('20150722082208');

INSERT INTO schema_migrations (version) VALUES ('20150722083030');

INSERT INTO schema_migrations (version) VALUES ('20150722083059');

INSERT INTO schema_migrations (version) VALUES ('20150722083116');

INSERT INTO schema_migrations (version) VALUES ('20150722122510');

INSERT INTO schema_migrations (version) VALUES ('20150722122521');

INSERT INTO schema_migrations (version) VALUES ('20150722122534');

INSERT INTO schema_migrations (version) VALUES ('20150724081310');

INSERT INTO schema_migrations (version) VALUES ('20150724082859');

INSERT INTO schema_migrations (version) VALUES ('20150724083127');

INSERT INTO schema_migrations (version) VALUES ('20150724083224');

INSERT INTO schema_migrations (version) VALUES ('20150724091101');

INSERT INTO schema_migrations (version) VALUES ('20150724091140');

INSERT INTO schema_migrations (version) VALUES ('20150724091150');

INSERT INTO schema_migrations (version) VALUES ('20150724091156');

INSERT INTO schema_migrations (version) VALUES ('20150817055844');

INSERT INTO schema_migrations (version) VALUES ('20150819024048');

INSERT INTO schema_migrations (version) VALUES ('20150819031104');

INSERT INTO schema_migrations (version) VALUES ('20150819074917');

INSERT INTO schema_migrations (version) VALUES ('20150819085817');

INSERT INTO schema_migrations (version) VALUES ('20150819090638');

INSERT INTO schema_migrations (version) VALUES ('20150819092950');

INSERT INTO schema_migrations (version) VALUES ('20150819093131');

INSERT INTO schema_migrations (version) VALUES ('20150819093146');

INSERT INTO schema_migrations (version) VALUES ('20150819093207');

INSERT INTO schema_migrations (version) VALUES ('20150904062204');

INSERT INTO schema_migrations (version) VALUES ('20150909035457');

INSERT INTO schema_migrations (version) VALUES ('20151105055739');

INSERT INTO schema_migrations (version) VALUES ('20151114095759');

INSERT INTO schema_migrations (version) VALUES ('20151116075628');

INSERT INTO schema_migrations (version) VALUES ('20151118072028');

INSERT INTO schema_migrations (version) VALUES ('20151208064522');

INSERT INTO schema_migrations (version) VALUES ('20151210145402');

INSERT INTO schema_migrations (version) VALUES ('20151211054956');

INSERT INTO schema_migrations (version) VALUES ('20151216062238');

INSERT INTO schema_migrations (version) VALUES ('20151216062547');

INSERT INTO schema_migrations (version) VALUES ('20151216062611');

INSERT INTO schema_migrations (version) VALUES ('20151216103103');

INSERT INTO schema_migrations (version) VALUES ('20151216110138');

INSERT INTO schema_migrations (version) VALUES ('20160106134405');

