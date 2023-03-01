"""created_on pls no null

Revision ID: b3f07657bc30
Revises: daad72fa8c6e
Create Date: 2023-02-23 11:52:43.261927

"""
from alembic import op
from sqlalchemy.dialects import postgresql

# revision identifiers, used by Alembic.
revision = "b3f07657bc30"
down_revision = "daad72fa8c6e"
branch_labels = None
depends_on = None


def upgrade():
    # jscpd:ignore-start
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column(
        "annual_membership",
        "created_on",
        existing_type=postgresql.TIMESTAMP(),
        nullable=False,
    )
    # ### end Alembic commands ###
    # jscpd:ignore-end
    sql = 'REASSIGN OWNED BY current_user TO "read_write"'
    op.execute(sql)


def downgrade():
    # ### commands auto generated by Alembic - please adjust! ###
    op.alter_column(
        "annual_membership",
        "created_on",
        existing_type=postgresql.TIMESTAMP(),
        nullable=True,
    )
    # ### end Alembic commands ###
