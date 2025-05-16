const { Model, DataTypes } = require('sequelize');
const sequelize = require('../database/connection');

class Project extends Model {}

Project.init({
  id: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true
  },
  title: {
    type: DataTypes.STRING(100),
    allowNull: false,
    validate: {
      notEmpty: true
    }
  },
  description: {
    type: DataTypes.TEXT,
    allowNull: true
  },
  image_path: {
    type: DataTypes.STRING(255),
    allowNull: true
  },
  technologies: {
    type: DataTypes.ARRAY(DataTypes.STRING),
    defaultValue: []
  },
  github_url: {
    type: DataTypes.STRING(255),
    allowNull: true,
    validate: {
      isUrl: true
    }
  },
  live_url: {
    type: DataTypes.STRING(255),
    allowNull: true,
    validate: {
      isUrl: true
    }
  },
  category: {
    type: DataTypes.STRING(50),
    allowNull: true
  },
  featured: {
    type: DataTypes.BOOLEAN,
    defaultValue: false
  },
  created_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  },
  updated_at: {
    type: DataTypes.DATE,
    defaultValue: DataTypes.NOW
  }
}, {
  sequelize,
  modelName: 'Project',
  tableName: 'projects',
  timestamps: true,
  underscored: true,
  hooks: {
    beforeUpdate: (project) => {
      project.updated_at = new Date();
    }
  }
});

module.exports = Project; 