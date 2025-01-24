package infrastructure

import (
	"github.com/peter7775/alevisualizer/internal/domain/models"
	"github.com/peter7775/alevisualizer/internal/domain/repositories"
	"github.com/peter7775/alevisualizer/internal/mysql"
	"github.com/peter7775/alevisualizer/internal/neo4j"
)

func NewMySQLRepository(config models.Config) (repositories.MySQLRepository, error) {
	client, err := mysql.NewMySQLClient(mysql.MySQLConfig{
		Host:     config.MySQL.Host,
		Port:     config.MySQL.Port,
		User:     config.MySQL.User,
		Password: config.MySQL.Password,
		Database: config.MySQL.Database,
	})
	if err != nil {
		return nil, err
	}
	return client, nil
}

func NewNeo4jRepository(config models.Config) (repositories.Neo4jRepository, error) {
	client, err := neo4j.NewNeo4jClient(neo4j.Neo4jConfig{
		URI:      config.Neo4j.URI,
		User:     config.Neo4j.User,
		Password: config.Neo4j.Password,
	})
	if err != nil {
		return nil, err
	}
	return client, nil
}
