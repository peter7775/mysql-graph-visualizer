/*
 * Copyright (c) 2025 Petr Miroslav Stepanek <petrstepanek99@gmail.com>
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package mysql

type MySQLConfig struct {
	Host     string
	Port     int
	User     string
	Password string
	Database string
}
